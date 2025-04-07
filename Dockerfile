FROM python:3.8-slim
RUN echo 'Pulling base image.'

RUN echo 'Installing Python packages.'
ADD requirements.txt /
RUN pip install -r /requirements.txt

RUN echo 'Adding the data, notebooks, and scripts directories, and docker-entrypoint.sh.'
COPY data/ /app/data
COPY notebooks/ /app/notebooks
COPY src/ /app/src
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

RUN echo 'Making /workspace/docker-entrypoint.sh executable.'
RUN chmod +x /app/docker-entrypoint.sh

RUN echo 'Setting /app as WORKDIR.'
WORKDIR /app

RUN echo 'Exposing port 8888 for Jupyter Notebooks.'
EXPOSE 8888

RUN echo 'Setting ENTRYPOINT to app/docker-entrypoint.sh.'
ENTRYPOINT ["/app/docker-entrypoint.sh"]
