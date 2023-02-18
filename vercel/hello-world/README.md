# Welcome

This guide assumes you have configured the [Vercel CLI](https://vercel.com/docs/cli) and authenticated with an account on [Vercel](https://vercel.com).

If you need guidance in getting this set up, please review the [README](../README.md) in this project's `vercel` folder.

## Getting started

### Local development

With the [Vercel CLI](https://vercel.com/docs/cli) installed on your system, we can use the CLI to spin up our local environment with:

```sh
% vercel dev
Vercel CLI 28.16.2
> Ready! Available at http://localhost:3000

```

You should be able to see the `Hello, world!` message by opening [http://localhost:3000/](http://localhost:3000/) in your favorite browser. Note that we have defined a redirect rule in [](./vercel.json) so that any requests for the root URL are automatically redirected to [http://localhost:3000/api](http://localhost:3000/api).

After a request has been made, you can press `CTRL+C` to cancel the process, and you will see something like this:

```sh
% vercel dev
Vercel CLI 28.16.2
> Ready! Available at http://localhost:3000
> Building @vercel/python@latest:api/index.py
Installing required dependencies...
> Built @vercel/python@latest:api/index.py [346ms]
using HTTP Handler
127.0.0.1 - - [18/Feb/2023 06:55:38] "GET /api HTTP/1.1" 200 -
^C
```

### Deploy to Vercel

When you are ready to deploy your project, you can use the [Vercel CLI](https://vercel.com/docs/cli) installed on your system:

```sh
% vercel deploy
Vercel CLI 28.16.2
🔍  Inspect: https://vercel.com/therobbrennan/hello-world/BaVqFoKnCsgfoARE5Seujpvin9wY [2s]
✅  Production: https://hello-world-six-pi.vercel.app [10s]
📝  Deployed to production. Run `vercel --prod` to overwrite later (https://vercel.link/2F).
💡  To change the domain or build command, go to https://vercel.com/therobbrennan/hello-world/settings
```

In the example output above, I can open [https://hello-world-six-pi.vercel.app](https://hello-world-six-pi.vercel.app) in my favorite browser - and automatically be directed to [https://hello-world-six-pi.vercel.app/api](https://hello-world-six-pi.vercel.app/api) as expected.
