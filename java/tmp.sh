javac EchoClient.java; ls -al * ../*  | xargs -n 1 -P 100 java EchoClient localhost
