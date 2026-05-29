import { createApp } from "./app.js";

const port = Number(process.env.PORT ?? 4000);

createApp()
  .then(({ app }) => {
    app.listen(port, () => {
      console.log(`PlayVerse API listening on http://localhost:${port}`);
    });
  })
  .catch((error) => {
    console.error("Failed to start PlayVerse API", error);
    process.exit(1);
  });
