# Use an official Julia image as the base image
FROM julia:1.8

# Set the working directory inside the container
WORKDIR /app

# Copy the project files into the container
COPY app.jl Project.toml ./

# Install the required packages globally to ensure they're available
RUN julia -e 'using Pkg; Pkg.add(["HTTP", "Plots", "JSON"])'

# Precompile the packages to improve startup time
RUN julia -e 'using HTTP, Plots, JSON'

# Create a default plot to precompile the plotting package
RUN julia -e 'using Plots; plot(1:10); savefig("precompile.png"); rm("precompile.png")'

# Expose port 8080 to the host
EXPOSE 8080

# Run the Julia app
CMD ["julia", "app.jl"]
