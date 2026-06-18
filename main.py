from tasks import add


def main():
    print("Hello from celery-and-rabbit!")
    print("Sending task to RabbitMQ...")
    result = add.delay(4, 6)

    print(f"Task sent successfully! Task ID: {result.id}")


if __name__ == "__main__":
    main()
