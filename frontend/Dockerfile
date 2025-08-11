# Use Amazon ECR Public Gallery nginx image to avoid Docker Hub rate limits
FROM public.ecr.aws/nginx/nginx:latest

# Copy the 2048 game files to the Nginx web root
COPY . /usr/share/nginx/html

# Expose the default Nginx HTTP port
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
