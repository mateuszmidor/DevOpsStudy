import server
import sys

if __name__ == '__main__':
    port = int(sys.argv[1])
    
    try:
        server.runServer(port)
    except:
        print("pngcoverter server killed. Bye!")