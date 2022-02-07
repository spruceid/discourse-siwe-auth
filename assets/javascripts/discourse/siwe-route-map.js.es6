export default function () {
  this.route(
    "siwe-auth",
    { path: "/discourse-siwe/auth" },
    function () {
      this.route("index", { path: "/" });
    }
  );
}
