# Julia Function Plotter Demo on Numerous

A simple web application built with Julia that demonstrates how to deploy and run Julia applications on the Numerous platform. The app showcases interactive function plotting with a modern web interface.

## Features

- Interactive web interface for mathematical function plotting
- Support for multiple function types:
  - Sine
  - Cosine
  - Tangent
  - Quadratic (x²)
  - Linear
- Customizable plot range and step size
- Real-time plot generation
- Containerized deployment using Docker
- Easy deployment to Numerous platform

## Local Development

### Prerequisites

- Julia 1.6+
- Docker (for container builds)
- Numerous CLI (for deployment)

### Running Locally

1. Clone this repository
2. Navigate to the project directory
3. Run directly with Julia:
   ```bash
   julia -e 'using Pkg; Pkg.add(["HTTP", "Plots", "JSON"])'
   julia app.jl
   ```
   Or using Docker:
   ```bash
   docker build -t julia-demo .
   docker run -p 8080:8080 julia-demo
   ```
4. Open your browser and navigate to http://localhost:8080

## Deploying to Numerous

1. Sign-up on www.numerous.com by clicking sign-up and follow the steps.


2. Install the Numerous CLI if you haven't already
   ```bash
   pip install numerous
   ```  

3. Login to Numerous:
   ```bash
   numerous login
   ```

4. Deploy your app:
   ```bash
   numerous deploy -o <your-organization-slug>
   ```
   To obtain an organization slug you can list your organizations with:
   ```bash
   numerous organization list
   ```

## Application Structure

- `app.jl` - Main application file containing the web server and plotting logic
- `Dockerfile` - Container configuration for building and running the app
- `Project.toml` - Julia package dependencies
- `numerous.toml` - Numerous platform configuration

## Usage

1. Access the deployed app through your Numerous dashboard or local instance
2. Select a function type from the dropdown menu
3. Adjust the plotting parameters:
   - Start Value: Beginning of x-axis range
   - End Value: End of x-axis range
   - Step Size: Granularity of the plot
4. Click "Generate Plot" to create and view the mathematical function

## Technical Details

The application is built using:
- Julia HTTP.jl for the web server
- Plots.jl for generating mathematical visualizations
- JSON.jl for data handling
- Docker for containerization
- Numerous platform for deployment and hosting 