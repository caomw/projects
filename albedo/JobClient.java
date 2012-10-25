import java.net.*;
import java.io.*;

// A client for our multithreaded JobServer.
public class JobClient{

    
    public static void main(String[] args){

        // First parameter has to be machine the job request came from 
        if(args.length == 0){
            System.out.println("Usage: JobClient <machineName>");
            return;
        }
        String machineName = args[0];

        for (int att = 0; att < 10; att++){
            
            Socket s = null;
            String host = "byss";
            // Create the socket connection to the JobServer.
            try{
                s = new Socket(host, 12111);
            }catch(UnknownHostException uhe){
                // Host unreachable
                System.out.println("Java error: Unknown host:" + host);
                s = null;
            }catch(IOException ioe){
                // Cannot connect to port on given host
                System.out.println("Java error: Cannot connect to server " + host
                                   + " at port 12111. Make sure it is running.");
                s = null;
            }
            
            if(s == null) continue;
            
            BufferedReader inStream = null;
            PrintWriter outStream = null;
            
            try{
                // Create the streams to send and receive information
                inStream  = new BufferedReader(new InputStreamReader(s.getInputStream()));
                outStream = new PrintWriter(new OutputStreamWriter(s.getOutputStream()));
                
                // // Since this is the client, we will initiate the talking.
                // // Send a string.
                //System.out.println("Will ask for a number");
                outStream.println(machineName);
                outStream.flush();
                // receive the reply.
                System.out.println("jobID=" + inStream.readLine()
                                   + " assigned to machine " + machineName + " in attempt " + att);
                outStream.flush();
                
                return;
            }catch(IOException ioe){
                System.out.println("Java error: Exception during communication. Server probably closed connection.");
            }finally{
                try{
                    // Close the streams
                    outStream.close();
                    inStream.close();
                    // Close the socket before quitting
                    s.close();
                }
                catch(Exception e){
                    e.printStackTrace();
                }                
            }

        } // end loop
        
    } // end main
        
} // end class