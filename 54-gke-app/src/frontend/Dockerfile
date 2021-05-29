FROM gcr.io/google-appengine/python

# Create a virtualenv for dependencies. This isolates these packages from system-level packages.
RUN virtualenv -p python3.7 /env
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Install dependencies
COPY requirements.txt /app
RUN pip3 install -r requirements.txt

# Add application code
COPY main.py /app

# Run the web service
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 main:app