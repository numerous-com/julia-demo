# app.jl
using HTTP
using Plots
using JSON

# Function to generate plot based on parameters
function generate_plot(func_type, start_val, end_val, step_val)
    x = start_val:step_val:end_val
    
    if func_type == "sin"
        y = sin.(x)
        title = "Sine Function"
    elseif func_type == "cos"
        y = cos.(x)
        title = "Cosine Function"
    elseif func_type == "tan"
        y = tan.(x)
        title = "Tangent Function"
    elseif func_type == "quadratic"
        y = x.^2
        title = "Quadratic Function"
    else
        y = x
        title = "Linear Function"
    end
    
    p = plot(x, y, title=title, label=func_type, lw=2)
    
    # Save the plot to a temporary file
    plot_path = "plot.png"
    savefig(p, plot_path)
    
    return plot_path
end

# HTML template for the main page
function get_html_template(message="")
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Julia Plot Generator</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
            .container { max-width: 800px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
            h1 { color: #4b0082; }
            form { margin: 20px 0; }
            select, input, button { padding: 8px; margin: 5px 0; border-radius: 4px; border: 1px solid #ddd; }
            button { background-color: #4b0082; color: white; cursor: pointer; border: none; }
            button:hover { background-color: #6a0dad; }
            .plot-container { margin-top: 20px; text-align: center; }
            .plot-container img { max-width: 100%; border: 1px solid #ddd; border-radius: 4px; }
            .message { color: #4b0082; font-weight: bold; margin-bottom: 10px; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Julia Function Plotter</h1>
            <div class="message">$message</div>
            <form action="/" method="post">
                <div>
                    <label for="func_type">Function Type:</label>
                    <select name="func_type" id="func_type">
                        <option value="sin">Sine</option>
                        <option value="cos">Cosine</option>
                        <option value="tan">Tangent</option>
                        <option value="quadratic">Quadratic (x²)</option>
                        <option value="linear">Linear (x)</option>
                    </select>
                </div>
                <div>
                    <label for="start_val">Start Value:</label>
                    <input type="number" step="0.1" name="start_val" id="start_val" value="-5">
                </div>
                <div>
                    <label for="end_val">End Value:</label>
                    <input type="number" step="0.1" name="end_val" id="end_val" value="5">
                </div>
                <div>
                    <label for="step_val">Step Size:</label>
                    <input type="number" step="0.01" name="step_val" id="step_val" value="0.1">
                </div>
                <button type="submit">Generate Plot</button>
            </form>
            <div class="plot-container">
                <img src="/plot.png" alt="Function Plot" id="plot-image">
            </div>
        </div>
    </body>
    </html>
    """
end

function request_handler(req)
    # Handle different routes
    if req.target == "/"
        if req.method == "GET"
            # Serve the initial page
            return HTTP.Response(200, ["Content-Type" => "text/html"], body=get_html_template())
        elseif req.method == "POST"
            # Process form submission
            body = String(req.body)
            params = HTTP.URIs.queryparams(body)
            
            try
                func_type = get(params, "func_type", "sin")
                start_val = parse(Float64, get(params, "start_val", "-5"))
                end_val = parse(Float64, get(params, "end_val", "5"))
                step_val = parse(Float64, get(params, "step_val", "0.1"))
                
                # Generate the plot
                generate_plot(func_type, start_val, end_val, step_val)
                
                message = "Plot generated successfully!"
                return HTTP.Response(200, ["Content-Type" => "text/html"], body=get_html_template(message))
            catch e
                message = "Error: $(e)"
                return HTTP.Response(400, ["Content-Type" => "text/html"], body=get_html_template(message))
            end
        end
    elseif req.target == "/plot.png"
        # Serve the generated plot image
        if isfile("plot.png")
            img_data = read("plot.png")
            return HTTP.Response(200, ["Content-Type" => "image/png"], body=img_data)
        else
            return HTTP.Response(404, "Plot not found")
        end
    else
        # Handle 404
        return HTTP.Response(404, "Not found")
    end
end

println("Starting server on port 8080...")
HTTP.serve(request_handler, "0.0.0.0", 8080)
