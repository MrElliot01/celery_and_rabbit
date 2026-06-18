This is a really basic example of how we are able to get celery and rabbit MQ working together, this is simply sending a basic message to rabbit and having a celery worker deal with it. The 

!celery worker does not send the message!

the application sends the message to RabbitMQ, it can see that it is a celery request and needs to go in the celery queue so it is put there, the celery worker simply checks the RabbitMQ queue to see if there are any requests and it handle what the task actually is, in this example adding two numbers together. simple but good learning material.

Before doing any of this you are going to want to ensure that you have a docker container running that has RabbitMQ running on it:

```docker run -d --name my-rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management```



Running the Celery worker to process the task:
```uv run celery -A tasks worker --loglevel=info```
Running the Celery task:

```uv run main.py```