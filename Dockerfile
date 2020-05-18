FROM python:3.7-slim as base

RUN pip install pipenv

WORKDIR /usr/src/app

COPY Pipfile* ./
RUN pipenv lock --requirements > requirements.txt
RUN pip install -r requirements.txt -t .

COPY makesite.py .
COPY static/ static/
COPY layout/ layout/
COPY content/ content/

RUN python makesite.py

FROM python:3-slim as test

WORKDIR /usr/src/app

COPY --from=base /usr/src/app/_site ./

CMD ["python", "-m", "http.server"]