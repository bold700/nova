/**
 * Telegram bot → OpenAI ChatGPT → antwoord terug naar Telegram.
 * Geen OpenClaw; alleen Telegram + OpenAI API.
 *
 * Gebruik:
 *   TELEGRAM_BOT_TOKEN=... OPENAI_API_KEY=... node index.js
 * Of: kopieer .env.example naar .env en vul in, dan: node index.js
 */

require('dotenv').config({ path: '.env' });
const { Telegraf } = require('telegraf');
const OpenAI = require('openai');

const TELEGRAM_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

if (!TELEGRAM_TOKEN) {
  console.error('Ontbrekend: TELEGRAM_BOT_TOKEN (in .env of omgeving)');
  process.exit(1);
}
if (!OPENAI_API_KEY) {
  console.error('Ontbrekend: OPENAI_API_KEY (in .env of omgeving)');
  process.exit(1);
}

const openai = new OpenAI({ apiKey: OPENAI_API_KEY });
const bot = new Telegraf(TELEGRAM_TOKEN);

// Als er ergens een fout optreedt tijdens polling of verwerken updates,
// willen we dat altijd zien in de console.
bot.catch((err, ctx) => {
  const from = ctx?.from ? `from=${ctx.from.id}` : 'from=?';
  const chat = ctx?.chat ? `chat=${ctx.chat.id}` : 'chat=?';
  console.error('Telegraf fout:', err?.message || err, from, chat);
});

// Snelle fallback zodat we meteen Telegram->bot->Telegram kunnen testen,
// los van de OpenAI-call.
bot.start(async (ctx) => {
  console.log(`[telegram] /start chat=${ctx.chat.id}`);
  await ctx.reply('Hoi! Ik ben online. Stuur "ping" of stel een vraag om ChatGPT te gebruiken.');
});

bot.command('ping', async (ctx) => {
  console.log(`[telegram] /ping chat=${ctx.chat.id}`);
  await ctx.reply('pong');
});

// Elke tekst (behalve commando's) → ChatGPT → reply
bot.on('text', async (ctx) => {
  const userText = (ctx?.message?.text || '').trim();
  if (!userText) return;
  // Negeer commando's hier; die worden al door bot.start/bot.command afgehandeld.
  if (userText.startsWith('/')) return;

  const chatId = ctx.chat.id;
  console.log(`[telegram] inkomend: chat=${chatId} text="${userText.slice(0, 200)}"`);

  try {
    const completion = await openai.chat.completions.create({
      model: process.env.OPENAI_MODEL || 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: process.env.SYSTEM_PROMPT || 'Je bent een behulpzame assistent. Antwoord kort en in het Nederlands tenzij de gebruiker anders vraagt.'
        },
        { role: 'user', content: userText }
      ],
      max_tokens: 1024
    });

    const reply = completion.choices[0]?.message?.content?.trim() || 'Geen antwoord.';
    await ctx.reply(reply);
  } catch (err) {
    console.error('OpenAI of Telegram fout:', err.message);
    await ctx.reply('Er ging iets mis bij het ophalen van een antwoord. Probeer het later opnieuw.');
  }
});

// Zorg dat er geen webhook actief is voor deze bot token; dan gebruiken we polling.
async function main() {
  console.log('[boot] telegram-chatgpt-bot start...');

  // Telegraf gebruikt polling; als er nog een webhook actief was voor deze token,
  // willen we die eerst uitzetten. Voeg timeout toe zodat we niet kunnen “hangen”.
  console.log('[boot] deleteWebhook (best effort)...');
  try {
    await Promise.race([
      bot.telegram.deleteWebhook(),
      new Promise((_, reject) => setTimeout(() => reject(new Error('deleteWebhook timeout')), 5000))
    ]);
    console.log('[boot] deleteWebhook klaar');
  } catch (e) {
    console.error('[boot] deleteWebhook faalde/timed out:', e.message || e);
  }

  console.log('[boot] bot launch...');
  try {
    bot.launch({ dropPendingUpdates: true });
    console.log('Telegram + ChatGPT bot draait. Stuur een bericht naar de bot.');
  } catch (e) {
    console.error('Telegram bot launch faalde:', e?.message || e);
  }
}

main();

process.once('SIGINT', () => bot.stop('SIGINT'));
process.once('SIGTERM', () => bot.stop('SIGTERM'));
