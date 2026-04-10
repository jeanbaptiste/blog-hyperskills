import { readFileSync, writeFileSync, readdirSync } from 'fs';
import { encode } from 'hyperskills';

const BLOG_URL = 'https://blog.hyperskills.net';
const dir = new URL('..', import.meta.url).pathname;

const htmlFiles = readdirSync(dir)
  .filter(f => f.endsWith('.html') && f !== 'index.html');

let updated = 0;

for (const htmlFile of htmlFiles) {
  const mdFile = htmlFile.replace('.html', '.md');
  const mdPath = dir + mdFile;
  const htmlPath = dir + htmlFile;

  let md;
  try {
    md = readFileSync(mdPath, 'utf-8');
  } catch {
    console.log(`SKIP ${htmlFile} — no ${mdFile}`);
    continue;
  }

  const sourceUrl = `${BLOG_URL}/${htmlFile}`;
  const hsUrl = await encode(sourceUrl, md, { compress: 'gzip' });

  let html = readFileSync(htmlPath, 'utf-8');

  // Check if there's already a hyperskill link placeholder or existing link
  const linkHtml = `<a href="${hsUrl}" title="Share as hyperskill">Share as hyperskill</a>`;

  if (html.includes('Share as hyperskill')) {
    // Replace existing link
    html = html.replace(
      /<a href="[^"]*"[^>]*>Share as hyperskill<\/a>/,
      linkHtml
    );
    console.log(`UPDATE ${htmlFile} — hyperskill link updated`);
  } else if (html.includes('</footer>')) {
    // Inject before </footer>
    html = html.replace(
      '</footer>',
      `  <p>${linkHtml}</p>\n</footer>`
    );
    console.log(`INJECT ${htmlFile} — hyperskill link added`);
  } else {
    console.log(`WARN ${htmlFile} — no footer found, skipping injection`);
    continue;
  }

  // Also ensure article:published_time meta exists
  if (!html.includes('article:published_time')) {
    // Try to read date from .md frontmatter
    const dateMatch = md.match(/^date:\s*"?(\d{4}-\d{2}-\d{2})"?/m);
    if (dateMatch) {
      const dateMeta = `<meta property="article:published_time" content="${dateMatch[1]}">`;
      html = html.replace('</head>', `${dateMeta}\n</head>`);
      console.log(`  + added article:published_time ${dateMatch[1]}`);
    }
  }

  writeFileSync(htmlPath, html);
  updated++;
}

console.log(`\nDone: ${updated} file(s) updated.`);
