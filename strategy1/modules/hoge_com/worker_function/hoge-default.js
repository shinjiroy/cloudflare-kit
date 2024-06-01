export default {
  async fetch(request, env, ctx) {
    let response = await fetch(request);
    // Reconstruct the Response object to make its headers mutable.
    response = new Response(response.body, response);
    return response;
  },
};
