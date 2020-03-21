https://www.youtube.com/watch?v=Gckn5T5V618&list=PLC2hWv6J_iIzt3140dXL-Ts31Owodl7lB&index=10

## Files

    - Chart.yaml - description of the app and chart
    - Values.yaml - customisation point; contains values to template deployment.yaml, service.yaml and ingress.yaml
    - templates/deployment.yaml - templated deployment object for our app
    - templates/service.yaml - templated service object for our app
    - templates/ingress.yaml - templated ingress object for our app
    - templates/NOTES.txt - templated readme to display after chart installation
    - templates/tests/test-connection.yaml - templated smoke test for the chart. Run it after installing chart with: helm test mychart
