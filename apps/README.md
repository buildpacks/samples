# Sample Apps

DISCLAIMER: There is nothing special about the apps here. The apps are solely here to complete samples and tutorials.

_No alterations are necessary to standard applications in order to be built by buildpacks._

### Running the apps
To build images for these apps, simply execute:

```bash
pack build -p apps/<APP> --builder cnbs/sample-builder:<bionic OR alpine> sample-app
```

_After building the app you should be able to simply run it via `docker run -it -p 8080:8080 sample-app`.
Go to [localhost:8080](http://localhost:8080) to see the app running._

### What's next?

It might be interesting to see how apps get turned into layers, eh? Check out [buildpacks](../buildpacks) to take the next step.
