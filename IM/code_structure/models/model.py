import gin 

import torch 
import torch.nn as nn 

# Here we illustrate two things :
#   - a short reminder on how to create a neural network using torch.nn 
#   - how to configure a class using the gin-config package
#
# You should check the base.gin file to see how to set 
# the hyperparameters of the network (here : input_dim, hidden_dim and output_dim)

@gin.configurable(module='networks')
class SimpleNetwork(nn.Module):
    def __init__(self, 
                 input_dim, 
                 hidden_dim, 
                 output_dim):
        super().__init__()
        
        # Here we build a very simple 2-layers MLP with ReLU activation
        
        self.net = nn.Sequential(
            nn.Linear(input_dim, hidden_dim), 
            nn.ReLU(), 
            nn.Linear(hidden_dim, output_dim)
        )
    
    def forward(self, x):
        return self.net(x)