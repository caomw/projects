mkdir sub64_cubes_45deg; ls sub16_cubes_45deg/*cub | parallel -P 16 ./scale_cube.sh 16 4 {}

