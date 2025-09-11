# ------------------------------------- Ch.1: Deep Learning with PyTorch -------------------------------------

# Lists into Tensors
import torch
my_list = [[1,2,3], [4,5,6]]

tensor = torch.tensor(my_list)
print(tensor)
print(tensor.shape)
print(tensor.dtype)


# Matrix Multiplication
a = torch.tensor([[1, 1],
                [2, 2]])
b = torch.tensor([[2, 2],
                  [3, 3]])
print(a @ b)
# Returns: tensor([[5, 5], [10, 10]])


# --------------------------------------------------------------------------

# Neural Networks
# Made up of Input Layer, Hidden Layer, and Output Layer
import torch.nn as nn

# The Input Neurons are Features, Here we create three Features. Note: Ouput Neurons are Classes
input_tensor = torch.tensor(
  [[0.3471, 0.4547, -0.2356]])

# We define our Linear Layer which connects the Input Neurons to the Hidden Layer
linear_layer = nn.Linear(
                          in_features=3,
                          out_features=2
)

# Pass Input through the Linear Layer to get an two Output Neurons
output = linear_layer(input_tensor)
print(output)
# Returns: tensor([[-0.2415, -0.1604]], grad_fn=<AddmmBackward0>)

#

























