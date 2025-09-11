export async function GET() {
    return new Response(
        JSON.stringify({
            app: process.env.APP_NAME || "unknown",
            env: process.env.NODE_ENV,
        }),
        {
            status: 200,
            headers: {
                "Content-Type": "application/json",
            },
        }
    );
}
