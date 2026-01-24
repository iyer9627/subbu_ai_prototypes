/**
 * AWS Lambda Handler for AI Processing
 *
 * This handler can be deployed to AWS Lambda for serverless AI processing
 */

const { AIService } = require('@ai-proto/ai-services');

exports.handler = async (event) => {
  try {
    const aiService = new AIService({
      defaultProvider: process.env.AI_PROVIDER,
      apiKeys: {
        anthropic: process.env.ANTHROPIC_API_KEY,
        openai: process.env.OPENAI_API_KEY
      }
    });

    const request = JSON.parse(event.body);
    const response = await aiService.sendRequest(request);

    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: true,
        data: response
      })
    };
  } catch (error) {
    console.error('Error processing request:', error);

    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({
        success: false,
        error: {
          code: 'INTERNAL_SERVER_ERROR',
          message: error.message
        }
      })
    };
  }
};
