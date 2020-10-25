import training
import server
import config
import sys
import os

if __name__ == '__main__':
    port = int(sys.argv[1])

    if not os.path.exists(config.TRAINED_MODEL_PATH):
        training.trainModel(config.TRAINED_MODEL_PATH)

    try:
        server.runServer(port)
    except:
        print("digitchecker server killed. Bye!")