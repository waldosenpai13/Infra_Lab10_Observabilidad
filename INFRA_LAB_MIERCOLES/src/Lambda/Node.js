const url = "https://aws.amazon.com/";

export const handler = async (event) => {
  try {
    const res = await fetch(url);

    console.info("waldorojas_13", res.status);

    return {
      statusCode: 200,
      body: JSON.stringify({
        mensaje: "OK",
        status: res.status
      })
    };

  } catch (e) {
    console.error(e);

    return {
      statusCode: 500,
      body: JSON.stringify({
        error: "Error"
      })
    };
  }
};