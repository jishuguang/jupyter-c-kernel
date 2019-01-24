FROM jupyter/minimal-notebook:latest
# 20190122

USER root

# modify update sources
RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirrors.aliyun.com\/ubuntu\//g' /etc/apt/sources.list

# modify timezone
RUN apt-get clean && apt-get update && apt-get install -y locales tzdata
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Ensure UTF-8 locale
RUN locale-gen zh_CN.UTF-8 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8

# avoid start error
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

WORKDIR /tmp

COPY ./ jupyter_c_kernel/

RUN pip install --no-cache-dir jupyter_c_kernel/ && \
    cd jupyter_c_kernel/jupyter_c_kernel && \
    /opt/conda/bin/python install_c_kernel --user

WORKDIR $HOME

USER $NB_UID