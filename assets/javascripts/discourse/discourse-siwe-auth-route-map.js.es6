export default function () {
    this.route('siwe/message', function () {
        this.route('siwe-message-index', { path: '/siwe/message' });
    });
}