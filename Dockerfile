FROM ballerina/ballerina:latest

# Copy your Ballerina project files
COPY . /app

# Set the working directory
WORKDIR /app

# Expose the port your API server listens on
EXPOSE 8080

# Define the command to run your Ballerina application
CMD ["bal", "run"]