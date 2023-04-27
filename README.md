<p align="center">
   <br/>
   <a href="https://next-auth.js.org" target="_blank"><img width="150px" src="https://next-auth.js.org/img/logo/logo-sm.png" /></a>
   <h3 align="center">NextAuth.js Example App</h3>
   <p align="center">
   Open Source. Full Stack. Own Your Data.
   </p>
   <p align="center" style="align: center;">
      <a href="https://npm.im/next-auth">
        <img alt="npm" src="https://img.shields.io/npm/v/next-auth?color=green&label=next-auth">
      </a>
      <a href="https://bundlephobia.com/result?p=next-auth-example">
        <img src="https://img.shields.io/bundlephobia/minzip/next-auth?label=next-auth" alt="Bundle Size"/>
      </a>
      <a href="https://www.npmtrends.com/next-auth">
        <img src="https://img.shields.io/npm/dm/next-auth?label=next-auth%20downloads" alt="Downloads" />
      </a>
      <a href="https://npm.im/next-auth">
        <img src="https://img.shields.io/badge/npm-TypeScript-blue" alt="TypeScript" />
      </a>
   </p>
</p>

This is an example app for NextAuth.js. 
This app is mainly used as a playground for NextAuth.js, Authetication strategies, HTTP State/Sessions, and persisting data in a local database & serverless database.

## HTTP Review

HTTP is the TCP/IP based application layer communication protocol which standardizes how the client and server communicate with each other. It defines how the content is requested and transmitted across the internet.

### HTTP Sessions

In client-server protocols, like HTTP, sessions consist of three phases:

1. The client establishes a TCP connection (or the appropriate connection if the transport layer is not TCP).
2. The client sends its request, and waits for the answer.
3. The server processes the request, sending back its answer, providing a status code and appropriate data.

As of HTTP/1.1, the connection is no longer closed after completing the third phase, and the client is now granted a further request: this means the second and third phases can now be performed any number of times.

For more information, see [HTTP sessions](https://developer.mozilla.org/en-US/docs/Web/HTTP/Session)

### HTTP Cookies

An HTTP cookie (web cookie, browser cookie) is a small piece of data that a server sends to a user's web browser. The browser may store the cookie and send it back to the same server with later requests. Typically, an HTTP cookie is used to tell if two requests come from the same browser—keeping a user logged in, for example. It remembers stateful information for the stateless HTTP protocol.

Cookies are mainly used for three purposes:

1. Session management
Logins, shopping carts, game scores, or anything else the server should remember

2. Personalization
User preferences, themes, and other settings

3. Tracking
Recording and analyzing user behavior

Cookies were once used for general client-side storage. While this made sense when they were the only way to store data on the client, modern storage APIs are now recommended. Cookies are sent with every request, so they can worsen performance (especially for mobile data connections). Modern APIs for client storage are the Web Storage API (localStorage and sessionStorage) and IndexedDB.

For more information, see [HTTP cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies)

## Auth Review

Authentication is the process of verifying someone’s identity. 

This is commonly seen as a login form when visiting a website or application, where you provide your credentials to a service, and that service verifies they’re correct.

After successful authentication, (in case of session-cookie approach) the server generates a “cookie”, or (in case of JWT approach) the server generates an “token".

In both approaches the client side must securely save the “cookie” or the “jwt token”.
The main difference is that in case of the JWT approach the server does not need to maintain a DB of sessionId for lookup.


### OAuth

OAuth stands for Open Authorization and is an open standard for authorization. It works to authorize devices, APIs, servers and applications using access tokens rather than user credentials, known as “secure delegated access”.

In its most simplest form, OAuth delegates authentication to services like Facebook, Amazon, Twitter and authorizes third-party applications to access the user account without having to enter their login and password.

It is mostly utilized for REST/APIs and only provides a limited scope of a user’s data.

Fore more information, see [An introduction to OAuth 2.0](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2)

**Callback URLs** - this will be what our auth service will use to communicate with Twitter when authenticating. When developing locally, it should be the address of your server. When on production, it should be your public-facing URL. You need to configure a callback URL in your provider's settingsEach provider has a "Configuration" section that should give you pointers on how to do that.

For callback urls, you can use <NEXTAUTH_URL>/api/auth/callback/<provider>.
I.g., http://localhost:3000/api/auth/callback/github.

### Session based authentication

- Stateful authentication

- Server creates a session for user after successful authentication. A session id is then stored on a cookie in the user's browser. While the user stays logged in, the cookie would be sent along with every subsequent request. The server can then compare the session id stored on the cookie against the session information stored in the memory to verify user’s identity and sends response with the corresponding state!

- Cookies are used as pieces of data used to identify the user and their preferences. The browser returns the cookie to the server every time the page is requested. Specific cookies like HTTP cookies are used to perform cookie-based authentication to maintain the session for each user.

- HTTP is a stateless protocol which means that each request made from the client to the server is treated as a standalone request; neither the client nor the server keeps track of the subsequent requests. Sessions allow you to change that; with sessions, the server has a way to associate some information with the client so that when the same client requests the server, it can retrieve that information.

- In case of the session cookie based approach, the sessionId does not contain any userId information, but is a random string generated and signed by the “secret key”. The sessionId is then saved within a sessionDB. The sessionDB is a database table that maps “sessionId” < — -> “userId”.
Since sessionIds are stored in a sessionDB, the “session cookie approach” is sometimes called “stateful” approach to managing sessions, since the “state” or “session” is saved within a DB.

#### Steps

1. Client > Signing up

Before anything else, the user has to sign up. The client posts a HTTP request to the server containing his/her username and password.

2. Server > Handling sign up

The server receives this request and hashes the password before storing the username and password in your database. This way, if someone gains access to your database they won't see your users' actual passwords.

3. Client > User login

Now your user logs in. He/she provides their username/password and again, this is posted as a HTTP request to the server.

4. Server > Validating login

The server looks up the username in the database, hashes the supplied login password, and compares it to the previously hashed password in the database. If it doesn't check out, we may deny them access by sending a 401 status code and ending the request.

5. Server > Generating access token

If everything checks out, we're going to create an access token, which uniquely identifies the user's session. Still in the server, we do two things with the access token:

Store it in the database associated with that user
Attach it to a response cookie to be returned to the client. Be sure to set an expiration date/time to limit the user's session
Henceforth, the cookies will be attached to every request (and response) made between the client and server.

6. Client > Making page requests

Back on the client side, we are now logged in. Every time the client makes a request for a page that requires authorization (i.e. they need to be logged in), the server obtains the access token from the cookie and checks it against the one in the database associated with that user. If it checks out, access is granted.



For more information, see:

- [How does cookie based authentication work?](https://stackoverflow.com/questions/17769011/how-does-cookie-based-authentication-work)

- [Session authentication](https://roadmap.sh/guides/session-authentication)

### Token Based Authentication

- Stateless authentication

- In the token based application, the server creates JWT with a secret and sends the JWT to the client.

- The client stores the JWT (usually in local storage) and includes JWT in the header with every request. The server would then validate the JWT with every request from the client and sends response.

- In case of the JWT approach, the accessToken itself contains the encrypted “userId”, and the accessToken is not saved within any sessionDB.
Since no DB is required in case of the “jwt approach”, it is sometimes called “stateless” approach to managing sessions, since no “state” or “session” is saved within a DB (it is contained within the JWT token itself). The JWT tokens are sometimes referred to as “Bearer Tokens” since all the information about the user i.e. “bearer” is contained within the token.

For more information, see:

- [JWT Auth](https://roadmap.sh/guides/jwt-authentication)
- [Token auth](https://roadmap.sh/guides/token-authentication)

## Overview

NextAuth.js is a complete open source authentication solution.

This is an example application that shows how `next-auth` is applied to a basic Next.js app.

The deployed version can be found at [`next-auth-example.vercel.app`](https://next-auth-example.vercel.app)


### About NextAuth.js

NextAuth.js is an easy to implement, full-stack (client/server) open source authentication library originally designed for [Next.js](https://nextjs.org) and [Serverless](https://vercel.com). Our goal is to [support even more frameworks](https://github.com/nextauthjs/next-auth/issues/2294) in the future.

Go to [next-auth.js.org](https://next-auth.js.org) for more information and documentation.

> *NextAuth.js is not officially associated with Vercel or Next.js.*

## Getting Started


### 1. Clone the repository and install dependencies

```
git clone https://github.com/nextauthjs/next-auth-example.git
cd next-auth-example
npm install
```

### 2. Configure your local environment

Copy the .env.local.example file in this directory to .env.local (which will be ignored by Git):

```
cp .env.local.example .env.local
```

Add details for one or more providers (e.g. Google, Twitter, GitHub, Email, etc).

#### Database

Use a database to **persist** data. A database is needed to persist user accounts and to support email sign in**. However, you can still use NextAuth.js for authentication without a database by using OAuth for authentication. If you do not specify a database, [JSON Web Tokens](https://jwt.io/introduction) will be enabled by default.

You **can** skip configuring a database and come back to it later if you want.

For more information about setting up a database, please check out the following links:

* Docs: [next-auth.js.org/adapters/overview](https://next-auth.js.org/adapters/overview)

### 3. Database (Optional, if not persisting data skip this step)

1. Create SQL migration file and execute it (sync schema and database): `pnpm prisma:migrate`

```bash
/workspaces/next-auth-example dev* ❯ pnpm prisma:migrate                                 16:36:13

> @ prisma:migrate:dev /workspaces/next-auth-example
> prisma migrate dev

Environment variables loaded from .env
Prisma schema loaded from prisma/schema.prisma
Datasource "db": MySQL database "nextauth" at "mysql:3306"

✔ Enter a name for the new migration: … init
Applying migration `20230424163951_init`

The following migration(s) have been created and applied from new schema changes:

migrations/
  └─ 20230424163951_init/
    └─ migration.sql

Your database is now in sync with your schema.

✔ Generated Prisma Client (4.13.0 | library) to ./node_modules/.pnpm/@prisma+client@4.13.0_prisma@4.13
.0/node_modules/@prisma/client in 98ms
```

2. Generate Prisma client `pnpm prisma:generate`

```bash
/workspaces/next-auth-example dev* ❯ pnpm predev                                         14s 16:39:59

> @ predev /workspaces/next-auth-example
> pnpm prisma:generate


> @ prisma:generate /workspaces/next-auth-example
> prisma generate

Environment variables loaded from .env
Prisma schema loaded from prisma/schema.prisma

✔ Generated Prisma Client (4.13.0 | library) to ./node_modules/.pnpm/@prisma+client@4.13.0_prisma@4.13.0/node_modules/@prisma/client in 112ms
You can now start using Prisma Client in your code. Reference: https://pris.ly/d/client
```
import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()
```
```

### 4. Configure Authentication Providers

1. Review and update options in `pages/api/auth/[...nextauth].js` as needed.

2. When setting up OAuth, in the developer admin page for each of your OAuth services, you should configure the callback URL to use a callback path of `{server}/api/auth/callback/{provider}`.

  e.g. For Google OAuth you would use: `http://localhost:3000/api/auth/callback/google`

  A list of configured providers and their callback URLs is available from the endpoint `/api/auth/providers`. You can find more information at https://next-auth.js.org/configuration/providers/oauth

3. You can also choose to specify an SMTP server for passwordless sign in via email.

### 5. Start the application

To run your site locally, use:

```
pnpm dev
```

If using database, view database, use:

```
pnpm studio
```

To run it in production mode, use:

```
pnpm build
pnpm start
```

### 6. Preparing for Production

Follow the [Deployment documentation](https://next-auth.js.org/deployment)

**Set Environment Variables for production.**

## License

ISC

