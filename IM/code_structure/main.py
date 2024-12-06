# This is your main.py file. This is the kind of script you will have to train your model, or, 
# generally speaking, to launch any kind of useful scripts
#
# It is useful to set up a command-line interface (CLI) so that you can specify values at run time
# to experiment with different settings, don't forget to save these in your config file !

import argparse
import os 

import gin 
import torch 

from models import SimpleNetwork
from tqdm import tqdm
# from dataset import create_mnist_dataset
# You could also use this syntax to import everything from a package
# from models import *

parser = argparse.ArgumentParser()
parser.add_argument('--hidden_dim', type=int, help='Hidden dimension of our small MLP')
parser.add_argument('--config', type=str, help='Path to a configuration file')
parser.add_argument('--run_dir', type=str, help='Where to store the results of your run')


# Here, we also manually define a fake input dimension
# However, when training your models, this will be the input dimension of 
# your data

fake_input_dim = 32

# Parse the values of the CLI
args = parser.parse_args()

# Parse the configuration file
gin.parse_config_file(args.config)

# Bind the user-provided arguments to the configuration 
# (here : input dimension and hidden dimension)
gin.bind_parameter('%INPUT_DIM', fake_input_dim)
gin.bind_parameter('%HIDDEN_DIM', args.hidden_dim)


# Create an instance of your network
model = SimpleNetwork()

# Create the directory that will store your results
os.makedirs(args.run_dir, exist_ok=True)

# Store your configuration file
with open(os.path.join(args.run_dir, 'config.gin'), 'w') as f:
    f.write(gin.operative_config_str())
    
# Train your model
print('This is where the training happens')

# Don't forget to regularly save checkpoints (i.e. state of your model+optimizer during training
# to either re-start training if the server crashes, to save your trained model, or for all other
# valid reason)

torch.save(model.state_dict(), os.path.join(args.run_dir, 'model_state_dict.pt'))

# Time to run everything