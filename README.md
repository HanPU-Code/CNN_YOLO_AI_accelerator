# CNN AI Accelerator using DARKNET-19 YOLO v3 Tiny
Our GOAL is to design HW AI accelerator that works low power, high performance.

Algorithm: DARKNET-19
AI Model: YOLO v3 Tiny
Boards: PYNQ-Z2 FPGA Borad
Main tool: Xilinx Vivado, Vitis AI

## Developing
  - [ ] Quantization DARKNET-19 parameters to INT8 type.
  - [ ] Coding reference code in python. (all parameters are called in txt files.)
  - [ ] Design Conv layer.
  - [ ] Design Pooling layer.

## Substep
### Quantization DARKNET-19 parameters to INT8 type.
  - My team discuss about Bacth Normalization.
    - For Implementation, We guess Bacth Norm is not essential & causes large HW resources.
    - That discussion would be great paper subjects.
   
### Coding reference code in python. (all parameters are called in txt files.)
  - That isn't too hard but we didn't get parameter txt files written by INT8 type.
  - OpenCV, TensorFlow, Numpy, etc... will be used.
  - https://github.com/ValentinFigue/TinyYOLOv3-PyTorch : developed the model from their work.
  - https://github.com/openvinotoolkit/open_model_zoo   : converted weight file from their work.

### Design Conv layer.
  - The components of Conv layer is "Convolution", "BatchNorm", and "Leaky ReLU".
  - Convolution layer
      - almost done.
      - top module and controller are remain.
  - BatchNorm
      - For HW resources problem, we determine delete BatchNorm layer.
      - all parts would be done and have problem, we will apply this layer.
  - Leaky ReLU
      - ReLU vs Leaky ReLU
      - One of our issues.
   
### Design Pooling layer.
