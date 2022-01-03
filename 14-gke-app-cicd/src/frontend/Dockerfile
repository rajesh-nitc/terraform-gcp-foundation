FROM gcr.io/google-appengine/python

RUN addgroup --gid 1000 frontend && \
    useradd -u 1000 -g 1000 -ms /bin/bash frontend && \
    chmod 0775 /home/frontend && \
    chown -R 1000:0 /home/frontend

# Create a virtualenv for dependencies. This isolates these packages from system-level packages.
RUN virtualenv -p python3.7 /home/frontend/env
ENV VIRTUAL_ENV /home/frontend/env
ENV PATH /home/frontend/env/bin:$PATH

WORKDIR /home/frontend/app

# Install dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Add application code
COPY main.py .

# Run the web service
CMD exec gunicorn --bind :$PORT --workers 1 --threads 4 main:app