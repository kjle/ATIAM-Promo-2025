from torchvision.transforms import ToTensor
from torchvision.datasets import MNIST

def create_mnist_dataset(download_path: str):
    return MNIST(root=download_path, train=True, download=True, 
                 transform=ToTensor())