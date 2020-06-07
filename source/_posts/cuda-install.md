---
title: Nvidia, Cuda 安裝
date: 2020-06-07 21:17:31
categories:
- AI
tags:
- tech
- tensorflow
- DeepLearning
---
> update at 2020 2/26 by JasonLuo
> test on Ubuntu 16.04
> install Nvidia Driver 440.59, Cuda 10.1, Cudnn 7.6.5
> compatible with tensorflow-gpu 2.1

<font size=4>
因為deep learning的套件更新速度很快，有時更新DL套件後相對應的cuda, nvidia driver也需要重新安裝，因此在這邊紀錄一下如何install, uninstall這些東西
</font>

<!--more-->

## Nvidia Driver
### 安裝之前
1. 首先，檢查顯卡是否可用```lspci -nnk | grep -i nvidia```，應出現下面這些
```
    01:00.0 VGA compatible controller [0300]: NVIDIA Corporation Device [10de:1b82] (rev a1)
     Kernel driver in use: nvidia
     Kernel modules: nvidiafb, nouveau, nvidia_drm, nvidia
    01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:10f0] (rev a1)
    02:00.0 VGA compatible controller [0300]: NVIDIA Corporation Device [10de:1b82] (rev a1)
     Kernel driver in use: nvidia
     Kernel modules: nvidiafb, nouveau, nvidia_drm, nvidia
    02:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:10f0] (rev a1)
    ```
2. 檢查是否已有安裝driver，可使用nvidia-smi或是dpkg -l 'nvidia*'檢查
    - `nvidia-smi`除了可以檢查是否有安裝，同時也可以看到一些資訊(使用數據量，driver版本等)
    ![](https://i.imgur.com/9nz0MCU.png)

    - `dpkg -l nvidia*`
    ![](https://i.imgur.com/ISM4ns0.png)
    
3. 下載Nvidia Driver，到[官網](https://www.nvidia.com/Download/index.aspx?lang=en-us)下載

### 解安裝Nvidia Driver
4. 解除安裝之前先進入command prompt然後stop running Graphics session (此步驟可省略)
    - 按下 `[Ctrl]+[Alt]+[F1~F6]` 然後登入作業系統
    - 關閉Graphics Session 
        `sudo service lightdm stop` (For Ubuntu)
5. 卸載Nvidia Driver，下面三個步驟選其中一個
    - sudo apt-get purge nvidia*
    - sudo /usr/bin/nvidia-uninstall
    - sudo NVIDIA-Linux-x86_64-418.43.run --uninstall
6. 重新開機
    - `reboot`
    
### 安裝Nvidia Driver
7. 安裝之前先進入command prompt然後stop running Graphics session
    - 按下 `[Ctrl]+[Alt]+[F1~F6]` 然後登入作業系統
    - 關閉Graphics Session 
        `sudo service lightdm stop` (For Ubuntu)

8. 安裝Nvidia Driver
    - `sudo chmod +x NVIDIA-Linux-x86_64-XXX.run` (在官網下載的檔案)
    - `sudo NVIDIA-Linux-x86_64-XXX.run`
9. 重新啟動電腦
    - `reboot`

10. 確認套件是否已經安裝
    - `dpkg -l nvidia*`
    - `nvidia-smi`

## Cuda
### 安裝之前
1. 如何確認電腦上的Cuda版本
    - cat /usr/local/cuda/version.txt
    - nvcc -V
2. 下載cuda，到[官網](https://developer.nvidia.com/cuda-toolkit-archive)下載cuda 10.1，選哪種下載都可以，我這邊是選擇runfile(local)
    or 用wget
### 移除Cuda
3. 移除舊版cuda，下面選一種(確保沒有/usr/local/cuda-XX.X資料夾)
    - `sudo apt-get --purge remove 'cuda*'` 
    - `sudo apt-get autoremove --purge cuda`
    - `sudo /usr/local/cuda-10.2/bin/cuda-uninstaller` 
      [官網上寫的](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#runfile-uninstallation)，cuda-10.2換成自己的版本

### 安裝Cuda
4. 開始安裝Cuda (記得先用chmod +x讓檔案可以執行，前面兩種不適用跑_linux檔的)
    1. `sudo ./cuda_10.1.105_418.39_linux.run --driver --silent`
    2. `sudo ./cuda_10.1.105_418.39_linux.run --toolkit --silent`
    3. `sudo ./cuda_10.1.105_418.39_linux.run --samples --silent`

5. **注意！！** 如果/tmp資料夾容量不夠時會不能安裝，需要給tmpdir=[YourDirectory]的參數，這邊我是給/home/tmp，所以上面的command會變成，同時/home/tmp要是chmod 777:
    1. `sudo ./cuda_10.1.105_418.39_linux.run --driver --silent --tmpdir=/home/tmp`
    2. `sudo ./cuda_10.1.105_418.39_linux.run --toolkit --silent --tmpdir=/home/tmp`
    3. `sudo ./cuda_10.1.105_418.39_linux.run --samples --silent --tmpdir=/home/tmp`

6. 安裝時若出現**Missing recommended library:libGLU.so**，則進行下面命令:
    - `sudo apt-get install libglu1-mesa libxi-dev libxmu-dev libglu1-mesa-dev`
    
7. 安裝Cuda之後，需要將cuda路徑加入 **~/.bashrc** 當中:
    ```bash
    export PATH=/usr/local/cuda/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/cuda/64:$LD_LIBRARY_PATH
    ```
    
8. 然後，`source ~/.bashrc`
9. 使用`nvcc -V`檢查是否安裝成功
    
## Cudnn (可以加速的套件)
### 安裝之前
1. 檢查主機上是否有cudnn及版本多少
    `cat /usr/local/cuda/include/cudnn.h | grep CUDNN_MAJOR -A 2`
2. 從[官網](https://developer.nvidia.com/cudnn)下載Cudnn，要下載CuDNN需要登錄，登錄後找尋與已安裝好的cuda版本相容的CuDNN(e.g. cuDNN v7.3.1 Library for Linux)
> tensorflow2.0需要v7.6以上的版本

### 刪除Cudnn
3. 刪除相關檔案，通常會在`/usr/local/cuda/include/`和`/usr/local/cuda/lib64/`資料夾中
    1. `sudo rm -f /usr/local/cuda/include/*cudnn*`
    2. `sudo rm -f /usr/local/cuda/lib64/*cudnn*`

### 安裝cudnn
4. 下載之後進行解打包、壓縮
    - `tar -xvf cudnn-10.1-linux-x64-v7.6.5.32.tgz`

5. 解完打包壓縮之後可以發現有個cuda的文件夾，裡面會有
    - cuda/include
    - cuda/lib64
    - cuda/NVIDIA_SLA_cuDNN_Support.txt
    
6. 複製檔案到cuda資料夾中
    - `sudo cp cuda/include/cudnn.h /usr/local/cuda/include/`
    - `sudo cp cuda/lib64/lib* /usr/local/cuda/lib64/`
        
7. 檢測Cudnn - 到cudnn_samples_v7檢測

## TensorRT (optional)
> 跟libnvinfer.so.6, libnvinfer_plugin.so.6的檔案有關

### 安裝
1. [下載TensorRT](https://developer.nvidia.com/tensorrt)，同樣也需要先登錄才能下載
2. 下載tar文件，並選擇相對應的系統
3. 解壓縮tar.gz檔案
    - `tar xzvf TensorRT-XXXXXXXXXXXXXX.tar`
4. 將路徑加入`LD_LIBRARY_PATH`
    - `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/TC184610137/TensorRT-4.0.2.6/lib`

5. 安裝TensorRT, uff, raphsurgeon
    ```bash=0
    cd TensorRT-XXXX/python
    sudo pip install tensorrt-6.0.1.5-cp36-none-linux_x86_64.whl
    ```
    ```bash=+
    ## install uff
    cd TensorRT-XXXX/uff
    pip install uff-0.6.5-py2.py3-none-any.whl
    ```
    ```bash=+
    ## install graphsurgeon
    cd TensorRT-XXXX/graphsurgeon
    pip install graphsurgeon-0.4.1-py2.py3-none-any.whl
    ```

6. 測試:
    ```python
    import tensorrt as trt
    import uff as uff
    ```

Ref:
- [Uninstall nvidia driver](https://www.linux.com/blog/install-uninstall-nvidia-driver-33179-ubuntu-linuxmint)
- [檢查gpu驅動程式是否安裝](http://samwhelp.github.io/book-ubuntu-qna/read/case/driver/install-driver-package/is-nvidia-driver-installed)
- [當/tmp資料夾容量不夠時](https://devtalk.nvidia.com/default/topic/1014448/cuda-installation-error-extraction-failed/)
- [安裝步驟](https://medium.com/@zihansyu/ubuntu-16-04-%E5%AE%89%E8%A3%9Dcuda-10-0-cudnn-7-3-8254cb642e70?fbclid=IwAR1ZTYfdlyH5NSSrGNEjo9NyKZibqZaazey6lGcr6a0mxgiJYowVouJNVbk)
- [TensorRT](https://zhuanlan.zhihu.com/p/85365075)

