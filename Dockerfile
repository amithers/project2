FROM ubuntu:latest
RUN apt-get update && apt-get -y update
RUN apt-get install -y build-essential python3.6 python3-pip python3-dev
RUN pip3 -q install pip --upgrade
RUN mkdir src
WORKDIR src/
COPY . .
RUN pip3 install jupyter
RUN pip3 install -U onnx2keras
RUN pip3 install -U onnxmltools
RUN pip3 install -U onnxruntime
RUN pip3 install tensorflow==2.2.0
RUN pip3 install numpy 
RUN pip3 install pandas 
RUN python3 train_model.py


# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter", "notebook", "--port=8889", "--no-browser", "--ip=0.0.0.0", "--allow-root"]

