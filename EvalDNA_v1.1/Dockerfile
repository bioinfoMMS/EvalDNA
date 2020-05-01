# Use the official image as a parent image
FROM fedora:latest

# Set the working directory
WORKDIR /usr/src/app

#RUN dnf -y update
RUN dnf -y install\
	R\
	wget\
	apt\
	perl\
        cpanminus\
    &&  rm -rf /var/lib/apt/lists/*

RUN cpanm File::Spec::Link

RUN INSTALL_PATH=/usr/src/app/anaconda \
    && wget http://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh \
    && bash Miniconda2-latest* -fbp $INSTALL_PATH 

ENV PATH=/root/anaconda/bin:$PATH
ENV PATH=/usr/src/app/anaconda/bin:$PATH

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/src/app/code/Reapr_1.0.18_for_Evaldna/third_party/pezmaster31-bamtools/lib


RUN conda install -y --channel=r --channel=bioconda --channel=conda-forge\
        biopython==1.74 \
        numpy==1.16.5 \
        python==2.7.15 \
        r-caret==6.0_83 \
        r-randomforest==4.6_14 \
        samtools==1.9 \
    && conda clean -ya

EXPOSE 8080

#Add a user  
RUN useradd --create-home --shell /bin/bash dockeruser 
USER dockeruser

#COPY . .

CMD cd code && python EvalDNA_v1.1.py -i ../data/chr8.unlocalized.scaf.fna -o chr8_CH -c ../data/config.txt && Rscript run_mammalian_model_v1.1.R ../results/model_input_chr8_CH.csv

