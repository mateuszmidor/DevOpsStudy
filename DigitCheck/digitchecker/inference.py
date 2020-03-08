from tensorflow import keras
import numpy as np 
import config

def checkDigit(greyscale_28x28x8bit : np.ndarray) -> str:
    """ Input is numpy array 28x28 of type byte """

    # prediction mechanism expects data in range 0..1
    input_image =  1.0 - greyscale_28x28x8bit / 255.0 # inversion is needed to recognize correctly for unknown reason...
    input_image *=input_image
    print(greyscale_28x28x8bit.shape)
    print(np.amin(greyscale_28x28x8bit))
    print(np.amax(greyscale_28x28x8bit))
    print(np.amin(input_image))
    print(np.amax(input_image))

    # tensorflow expects a series of images, so called "tensor". So we convert image into array of size 1x28x28
    input_image_for_tensorflow = np.expand_dims(input_image, 0)

    # read calculated earlier model
    model =  keras.models.load_model(config.TRAINED_MODEL_PATH)

    # recognize digit. Result is array [1, 10], numbers in range 0..1
    prediction_result = model.predict(input_image_for_tensorflow)
    predicted_label = np.argmax(prediction_result)

    print("Prediction results:")
    for i, f in enumerate(prediction_result[0]):
        print("  {} - {:02d}%".format(i, int(f*100)))

    return str(predicted_label) if prediction_result[0, predicted_label] > 0.5 else '?'