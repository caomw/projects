#include <vw/Cartography/CameraBBox.h>
#include <vw/Image/ImageView.h>
#include <vw/Image/Transform.h>
#include <vw/Stereo/DisparityMap.h>
#include <asp/Tools/stereo.h>
using namespace vw;
using namespace vw::cartography;

namespace asp {
  template <class ImageT, class DEMImageT>
  class DemDisparity : public ImageViewBase<DemDisparity<ImageT, DEMImageT> > {
    ImageT m_left_image;
    double m_dem_accuracy;
    GeoReference m_dem_georef;
    const DEMImageT & m_dem;
    Vector2f m_downsample_scale;
    boost::shared_ptr<camera::CameraModel> m_left_camera_model;
    boost::shared_ptr<camera::CameraModel> m_right_camera_model;
    bool m_homography_align;
    Matrix<double>  m_align_matrix;
    int m_pixel_sample;
    ImageView<PixelMask<Vector2i> > & m_disparity_spread;

  public:
    DemDisparity( ImageViewBase<ImageT> const& left_image,
                  double dem_accuracy, GeoReference dem_georef,
                  DEMImageT const& dem,
                  Vector2f const& downsample_scale,
                  boost::shared_ptr<camera::CameraModel> left_camera_model,
                  boost::shared_ptr<camera::CameraModel> right_camera_model,
                  bool homography_align, Matrix<double> const& align_matrix,
                  int pixel_sample, ImageView<PixelMask<Vector2i> > & disparity_spread)
      :m_left_image(left_image.impl()),
       m_dem_accuracy(dem_accuracy),
       m_dem_georef(dem_georef),
       m_dem(dem),
       m_downsample_scale(downsample_scale),
       m_left_camera_model(left_camera_model),
       m_right_camera_model(right_camera_model),
       m_homography_align(homography_align),
       m_align_matrix(align_matrix),
       m_pixel_sample(pixel_sample),
       m_disparity_spread(disparity_spread){}

    // Image View interface
    typedef PixelMask<Vector2i> pixel_type;
    typedef pixel_type result_type;
    typedef ProceduralPixelAccessor<DemDisparity> pixel_accessor;

    inline int32 cols() const { return m_left_image.cols(); }
    inline int32 rows() const { return m_left_image.rows(); }
    inline int32 planes() const { return 1; }

    inline pixel_accessor origin() const { return pixel_accessor( *this, 0, 0 ); }

    inline pixel_type operator()( double /*i*/, double /*j*/, int32 /*p*/ = 0 ) const {
      vw_throw(NoImplErr() << "DemDisparity::operator()(...) is not implemented");
      return pixel_type();
    }

    typedef CropView<ImageView<pixel_type> > prerasterize_type;
    inline prerasterize_type prerasterize(BBox2i const& bbox) const {

      std::cout << "start box " << bbox << std::endl;

      prerasterize_type lowres_disparity = prerasterize_type(ImageView<pixel_type>(bbox.width(),
                                                                                   bbox.height()),
                                                             -bbox.min().x(), -bbox.min().y(),
                                                             cols(), rows() );

      for (int row = bbox.min().y(); row < bbox.max().y(); row++){
        for (int col = bbox.min().x(); col < bbox.max().x(); col++){
          lowres_disparity(col, row).invalidate();
          m_disparity_spread(col, row).invalidate();
        }
      }

      double height_error_tol = std::max(m_dem_accuracy/4.0, 1.0); // height error in meters
      double max_abs_tol = height_error_tol/4.0; // abs cost function change b/w iterations
      double max_rel_tol = 1e-14;                // rel cost function change b/w iterations
      int num_max_iter   = 50;
      bool treat_nodata_as_zero = false;

      // Debug code
      //DiskImageView<PixelMask<Vector2f> > disk_disp("run3/res-F.tif");

      Vector3 prev_xyz;

      // Estimate the DEM region we expect to use and crop it into an ImageView.
      // This will make the algorithm much faster than accessing individual
      // DEM pixels from disk. To do that, find the pixel values on a small set of points
      // of the diagonals of the current tile.
#if 1

      std::vector<Vector2> diagonals;
      int wid = bbox.width() - 1, hgt = bbox.height() - 1, dim = std::max(1, std::max(wid, hgt)/10);
      for (int i = 0; i <= dim; i++)
        diagonals.push_back(bbox.min() + Vector2(double(i)*wid/dim, double(i)*hgt/dim));
      for (int i = 0; i <= dim; i++)
        diagonals.push_back(bbox.min() + Vector2(double(i)*wid/dim, hgt - double(i)*hgt/dim));

      BBox2i dem_box;
      for (unsigned k = 0; k < diagonals.size(); k++){
        Vector2 left_lowres_pix = diagonals[k];
        Vector2 left_fullres_pix = elem_quot(left_lowres_pix, m_downsample_scale);
        bool has_intersection;
        Vector3 left_camera_ctr, left_camera_vec;
        try {
          left_camera_ctr = m_left_camera_model->camera_center(left_fullres_pix);
          left_camera_vec = m_left_camera_model->pixel_to_vector(left_fullres_pix);
        } catch (const camera::PixelToRayErr& /*e*/) {
          continue;
        }
        Vector3 xyz = camera_pixel_to_dem_xyz(left_camera_ctr, left_camera_vec,
                                              m_dem, m_dem_georef,
                                              treat_nodata_as_zero,
                                              has_intersection,
                                              height_error_tol, max_abs_tol,
                                              max_rel_tol, num_max_iter,
                                              prev_xyz
                                              );
        if ( !has_intersection || xyz == Vector3() ) continue;
        prev_xyz = xyz;

        Vector3 llh = m_dem_georef.datum().cartesian_to_geodetic( xyz );
        Vector2 pix = round(m_dem_georef.lonlat_to_pixel(subvector(llh, 0, 2)));
        dem_box.grow(pix);
      }

      // Expand the DEM box just in case as the above calculation is
      // not fool-proof if the DEM has a lot of no-data regions.
      int expand = std::max(100, (int)(0.1*std::max(dem_box.width(), dem_box.height())));
      dem_box.expand(expand);
      dem_box.crop(bounding_box(m_dem));

      // Crop the georef, read the DEM region in memory
      GeoReference georef_crop = crop(m_dem_georef, dem_box);
      ImageView <PixelMask<float> > dem_crop = crop(m_dem, dem_box);

#else
      GeoReference georef_crop = m_dem_georef;
      const DEMImageT & dem_crop = m_dem;
#endif

      for (int row = bbox.min().y(); row < bbox.max().y(); row++){
        if (row%m_pixel_sample != 0) continue;

        // Must wipe the previous guess since we are now too far from it
        prev_xyz = Vector3();

        for (int col = bbox.min().x(); col < bbox.max().x(); col++){
          if (col%m_pixel_sample != 0) continue;

          Vector2 left_lowres_pix = Vector2(col, row);
          Vector2 left_fullres_pix = elem_quot(left_lowres_pix, m_downsample_scale);
          bool has_intersection;
          Vector3 left_camera_ctr, left_camera_vec;
          try {
            left_camera_ctr = m_left_camera_model->camera_center(left_fullres_pix);
            left_camera_vec = m_left_camera_model->pixel_to_vector(left_fullres_pix);
          } catch (const camera::PixelToRayErr& /*e*/) {
            continue;
          }
          Vector3 xyz = camera_pixel_to_dem_xyz(left_camera_ctr, left_camera_vec,
                                                dem_crop, georef_crop,
                                                treat_nodata_as_zero,
                                                has_intersection,
                                                height_error_tol, max_abs_tol,
                                                max_rel_tol, num_max_iter,
                                                prev_xyz
                                                );
          if ( !has_intersection || xyz == Vector3() ) continue;
          prev_xyz = xyz;

          std::cout.precision(20);
          //xxxstd::cout << "point is " << col << ' ' << row << ' ' << xyz << std::endl;

          //Vector2 left_fullres_pix2 = m_left_camera_model->point_to_pixel(xyz);
          //std::cout << "norm error is " << left_fullres_pix << " " << norm_2(left_fullres_pix - left_fullres_pix2) << std::endl;

          // Since our DEM is only known approximately, the true
          // intersection point of the ray coming from the left camera
          // with the DEM could be anywhere within m_dem_accuracy from
          // xyz. Use that to get an estimate of the disparity
          // accuracy.

          ImageView< PixelMask<Vector2> > curr_pixel_disp_range(3, 1);
          double bias[] = {-1.0, 1.0, 0.0};
          int success[] = {0, 0, 0};

          for (int k = 0; k < curr_pixel_disp_range.cols(); k++){

            Vector2 right_fullres_pix;
            try {
              right_fullres_pix = m_right_camera_model->point_to_pixel(xyz + bias[k]*m_dem_accuracy*left_camera_vec);
            } catch ( camera::PointToPixelErr const& e ) {
              curr_pixel_disp_range(k, 0).invalidate();
              continue;
            }
            if (m_homography_align){
              right_fullres_pix = HomographyTransform(m_align_matrix).forward(right_fullres_pix);
            }

            // Debug code
            //std::cout.precision(20); std::cout << "\n\ncol row is " << col << ' ' << row << ' ' << cols() << " " << right_fullres_pix << ' ' << rows() << std::endl << std::endl << std::endl;
            //int k0 = int(left_fullres_pix[0]);
            //int k1 = int(left_fullres_pix[1]);
            //Vector2 fdisp = right_fullres_pix - left_fullres_pix;
            //PixelMask<Vector2i> ddisp = disk_disp(k0, k1);
            //std::cout << "pixel curr_pixel_disp_range: " << k0 << ' ' << k1 << ' ' << fdisp << ' ' << ddisp << " " << norm_2(ddisp.child() - fdisp) << std::endl;

            Vector2 right_lowres_pix = elem_prod(right_fullres_pix, m_downsample_scale);
            curr_pixel_disp_range(k, 0) = right_lowres_pix - left_lowres_pix;
            success[k] = 1;

            //std::cout << "value: " << col << ' ' << row << ' ' << k << ' ' << curr_pixel_disp_range(k, 0) << std::endl;

            // If the disparities at the endpoints of the range were successful,
            // don't bother with the middle estimate.
            if (k == 1 && success[0] && success[1]) break;
          }

          BBox2f search_range = stereo::get_disparity_range(curr_pixel_disp_range);
          if (search_range ==  BBox2f(0,0,0,0)) continue;

          lowres_disparity(col, row) = round( (search_range.min() + search_range.max())/2.0 );
          m_disparity_spread(col, row) = ceil( (search_range.max() - search_range.min())/2.0 );

          //std::cout << "range is " << search_range << std::endl;
          //xxxstd::cout << "disp is " << lowres_disparity(col, row) << std::endl;
          //std::cout << "accuracy is " << m_disparity_spread(col, row) << std::endl;
          //std::cout << std::endl;

        }
      }

//       End_t = time(NULL);    //record time that task 1 ends
//       time_task = difftime(End_t, Start_t);    //compute elapsed time of task 1
//       std::cout << "finish box " << bbox << " " << time_task << std::endl;

      return lowres_disparity;
    }

    template <class DestT>
    inline void rasterize(DestT const& dest, BBox2i bbox) const {
      vw::rasterize(prerasterize(bbox), dest, bbox);
    }
  };

  template <class ImageT, class DEMImageT>
  DemDisparity<ImageT, DEMImageT>
  dem_disparity( ImageViewBase<ImageT> const& left,
                 double dem_accuracy, GeoReference dem_georef,
                 DEMImageT const& dem,
                 Vector2f const& downsample_scale,
                 boost::shared_ptr<camera::CameraModel> left_camera_model,
                 boost::shared_ptr<camera::CameraModel> right_camera_model,
                 bool homography_align, Matrix<double> const& align_matrix,
                 int pixel_sample,
                 ImageView<PixelMask<Vector2i> > & disparity_spread
                 ) {
    typedef DemDisparity<ImageT, DEMImageT> return_type;
    return return_type( left.impl(),
                        dem_accuracy, dem_georef,
                        dem, downsample_scale,
                        left_camera_model, right_camera_model,
                        homography_align, align_matrix,
                        pixel_sample, disparity_spread
                        );
  }

  void produce_lowres_disparity( Options & opt ) {

    DiskImageView<vw::uint8> Lmask(opt.out_prefix + "-lMask.tif"),
      Rmask(opt.out_prefix + "-rMask.tif");

    DiskImageView<PixelGray<float> > left_sub( opt.out_prefix+"-L_sub.tif" ),
      right_sub( opt.out_prefix+"-R_sub.tif" );

    Vector2f downsample_scale( float(left_sub.cols()) / float(Lmask.cols()),
                               float(left_sub.rows()) / float(Lmask.rows()) );

    DiskImageView<uint8> left_mask_sub( opt.out_prefix+"-lMask_sub.tif" ),
      right_mask_sub( opt.out_prefix+"-rMask_sub.tif" );

    BBox2i search_range( floor(elem_prod(downsample_scale,stereo_settings().search_range.min())),
                         ceil(elem_prod(downsample_scale,stereo_settings().search_range.max())) );

    if ( stereo_settings().seed_mode == 1 ) {

    }else if ( stereo_settings().seed_mode == 2 ) {

      // Use a DEM to get the low-res disparity

      if (stereo_settings().is_search_defined())
        vw_out(WarningMessage) << "Computing low-resolution disparity from DEM. "
                               << "Will ignore corr-search value: "
                               << stereo_settings().search_range << ".\n";


      // Skip pixels to speed things up, particularly for ISIS and DG.
      int pixel_sample = 2;

      //char * pt = getenv("SAMPLE");
      //if (pt && atoi(pt) > 0) pixel_sample = atoi(pt);
      //std::cout << "using sample: " << pixel_sample << std::endl;

      // To do: We don't need again the images below here
      DiskImageView<PixelGray<float> > left_image(opt.out_prefix+"-L.tif");
      DiskImageView<PixelGray<float> > left_image_sub(opt.out_prefix+"-L_sub.tif");

      std::string dem_file = stereo_settings().disparity_estimation_dem;
      if (dem_file == ""){
        vw_throw( ArgumentErr() << "stereo_corr: No value was provided for: disparity-estimation-dem.\n" );
      }
      double dem_accuracy = stereo_settings().disparity_estimation_dem_accuracy;
      if (dem_accuracy <= 0.0){
        vw_throw( ArgumentErr() << "stereo_corr: Invalid value for disparity-estimation-dem-accuracy: " << dem_accuracy << ".\n" );
      }

      GeoReference dem_georef;
      bool has_georef = cartography::read_georeference(dem_georef, dem_file);
      if (!has_georef)
        vw_throw( ArgumentErr() << "There is no georeference information in: " << dem_file << ".\n" );

      DiskImageView<float> dem_disk_image(dem_file);
      ImageViewRef<PixelMask<float > > dem_ref = pixel_cast<PixelMask<float> >(dem_disk_image);
      boost::scoped_ptr<SrcImageResource> rsrc( DiskImageResource::open(dem_file) );
      if ( rsrc->has_nodata_read() ){
        double nodata_value = rsrc->nodata_read();
        if ( !std::isnan(nodata_value) )
          dem_ref = create_mask(dem_disk_image, nodata_value);
      }

      // Rasterize the results to a temporary file on disk so as to
      // speed up processing, which accesses each pixel multiple
      // times.
      //typedef BlockRasterizeView< ImageViewRef<PixelMask<float > > > PointCacheT;
      //PointCacheT dem =
      //block_cache(dem_ref, Vector2i(vw_settings().default_tile_size(),
      //                              vw_settings().default_tile_size()),0);
      //asp::block_write_gdal_image( "tmp.tif", dem_ref, opt,
      //TerminalProgressCallback("asp", "") );
      //ImageView<PixelMask<float > > dem = dem_ref;
      //DiskImageView<PixelMask<float > > dem("tmp.tif");
      ImageViewRef<PixelMask<float > > dem = dem_ref;

      // To do: This scale is duplicated
      Vector2f downsample_scale( float(left_image_sub.cols()) / float(left_image.cols()),
                                 float(left_image_sub.rows()) / float(left_image.rows()) );

      boost::shared_ptr<camera::CameraModel> left_camera_model, right_camera_model;
      opt.session->camera_models(left_camera_model, right_camera_model);

      Matrix<double> align_matrix = identity_matrix<3>();
      bool homography_align = (stereo_settings().alignment_method == "homography");
      if ( homography_align ) {
        // We used a homography to line up the images, we may want
        // to generate pre-alignment disparities before passing this information
        // onto the camera model in the next stage of the stereo pipeline.
        read_matrix(align_matrix, opt.out_prefix + "-align.exr");
        vw_out(DebugMessage,"asp") << "Alignment Matrix: " << align_matrix << "\n";
      }


      // To do: Must transform the disparities properly in all cases, for all session types and
      // map and non-map projected images.

      // To do: Warn the user that the corr-search-range is ignored!

      time_t Start_t, End_t;
      int time_task;
      Start_t = time(NULL);

      // Smaller tiles is better
      //---------------------------------------------------------
      Vector2 orig_tile_size = opt.raster_tile_size;
      opt.raster_tile_size = Vector2i(64, 64);

      // This image is small enough that we can keep it in memory
      ImageView<PixelMask<Vector2i> > disparity_spread(left_image_sub.cols(), left_image_sub.rows());

      ImageViewRef<PixelMask<Vector2i> > lowres_disparity
        = dem_disparity(left_image_sub,
                        dem_accuracy, dem_georef,
                        dem, downsample_scale,
                        left_camera_model, right_camera_model,
                        homography_align, align_matrix, pixel_sample,
                        disparity_spread
                        );
      std::string disparity_file = opt.out_prefix + "-D_sub.tif";
      vw_out() << "Writing low-resolution disparity: " << disparity_file << "\n";
      if ( opt.stereo_session_string == "isis" ){
        // ISIS does not support multi-threading
        // To do: Make consistent with what is below
        boost::scoped_ptr<DiskImageResource> drsrc( asp::build_gdal_rsrc( disparity_file,
                                                                        lowres_disparity, opt ) );
        write_image(*drsrc, lowres_disparity,
                    TerminalProgressCallback("asp", "\t--> Low-resolution disparity: "));
      }else{
        std::cout << "--not isis" << std::endl;
        asp::block_write_gdal_image( disparity_file,
                                     lowres_disparity,
                                     opt,
                                     TerminalProgressCallback("asp", "\t--> Low-resolution disparity:") );
      }

      std::string disp_spread_file = opt.out_prefix + "-D_sub_spread.tif";
      vw_out() << "Writing low-resolution disparity spread: " << disp_spread_file << "\n";
      asp::block_write_gdal_image( disp_spread_file,
                                     disparity_spread,
                                     opt,
                                     TerminalProgressCallback("asp", "\t--> Low-resolution disparity spread:") );

      End_t = time(NULL);    //record time that task 1 ends
      time_task = difftime(End_t, Start_t);    //compute elapsed time of task 1
      std::cout << "elapsed time: " << time_task << std::endl;

      // Go back to the original tile size
      opt.raster_tile_size = orig_tile_size;

#if 1 // Debug code
      ImageView<PixelMask<Vector2i> > lowres_disparity_disk;
      read_image( lowres_disparity_disk, opt.out_prefix + "-D_sub.tif" );
      ImageView<PixelMask<Vector2i> > lowres_disparity2(lowres_disparity_disk.cols()/pixel_sample, lowres_disparity_disk.rows()/pixel_sample);
      for (int col = 0; col < lowres_disparity2.cols(); col++){
        for (int row = 0; row < lowres_disparity2.rows(); row++){
          lowres_disparity2(col, row) = lowres_disparity_disk(pixel_sample*col, pixel_sample*row);
        }
      }
      asp::block_write_gdal_image( opt.out_prefix + "-D_sub2.tif",
                                   lowres_disparity2,
                                   opt,
                                   TerminalProgressCallback("asp", "\t--> Low-resolution disparity:") );
#endif


    }

    ImageView<PixelMask<Vector2i> > lowres_disparity;
    read_image( lowres_disparity, opt.out_prefix + "-D_sub.tif" );
    search_range =
      stereo::get_disparity_range( lowres_disparity );
    VW_OUT(DebugMessage,"asp") << "D_sub resolved search range: "
                               << search_range << " px\n";
    search_range.min() = floor(elem_quot(search_range.min(),downsample_scale));
    search_range.max() = ceil(elem_quot(search_range.max(),downsample_scale));
    stereo_settings().search_range = search_range;
  }

}

int main(){

  return 0;

}
