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
> Building @vercel/python@latest:api/index.py
Installing required dependencies...
> Built @vercel/python@latest:api/index.py [4s]
using HTTP Handler
127.0.0.1 - - [18/Feb/2023 07:17:18] "GET /api HTTP/1.1" 200 -
^C

```

You should be able to see a random roll of a six-side die by opening [http://localhost:3000/](http://localhost:3000/) in your favorite browser. Note that we have defined a redirect rule in [](./vercel.json) so that any requests for the root URL are automatically redirected to [http://localhost:3000/api](http://localhost:3000/api).

After a request has been made, you can press `CTRL+C` to cancel the process, and you will see something like this:

```sh
% vercel dev
Vercel CLI 28.16.2
> Ready! Available at http://localhost:3000
> Building @vercel/python@latest:api/index.py
Installing required dependencies...
> Built @vercel/python@latest:api/index.py [4s]
using HTTP Handler
127.0.0.1 - - [18/Feb/2023 07:17:18] "GET /api HTTP/1.1" 200 -
^C
```

### Deploy to Vercel

When you are ready to deploy your project, you can use the [Vercel CLI](https://vercel.com/docs/cli) installed on your system:

```sh
% vercel deploy
Vercel CLI 28.16.2
? Set up and deploy “~/repos/explore-nhl-api-with-r-and-python/vercel/dice-roll”? [Y/n] y
? Which scope do you want to deploy to? TheRobBrennan
? Link to existing project? [y/N] n
? What’s your project’s name? dice-roll
? In which directory is your code located? ./
Local settings detected in vercel.json:
No framework detected. Default Project Settings:
- Build Command: `npm run vercel-build` or `npm run build`
- Development Command: None
- Install Command: `yarn install`, `pnpm install`, or `npm install`
- Output Directory: `public` if it exists, or `.`
? Want to modify these settings? [y/N] n
🔗  Linked to therobbrennan/dice-roll (created .vercel)
🔍  Inspect: https://vercel.com/therobbrennan/dice-roll/GLgWzkR2SWUTXf6m7VyDb11ZVE9v [932ms]
✅  Production: https://dice-roll-omega.vercel.app [27s]
📝  Deployed to production. Run `vercel --prod` to overwrite later (https://vercel.link/2F).
💡  To change the domain or build command, go to https://vercel.com/therobbrennan/dice-roll/settings
```

In the example output above, I can open [https://dice-roll-omega.vercel.app/](https://dice-roll-omega.vercel.app/) in my favorite browser - and automatically be directed to [https://dice-roll-omega.vercel.app/api](https://dice-roll-omega.vercel.app/api) as expected.
