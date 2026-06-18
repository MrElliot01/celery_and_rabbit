from celery import Celery


app = Celery("tasks", broker="amqp://guest:guest@localhost:5672//")


@app.task
def hello():
    return "Hello, there how are you!"


def add(x, y):
    print(f"Executing task: Adding {x} + {y}")
    return x + y
