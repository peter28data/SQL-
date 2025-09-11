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
