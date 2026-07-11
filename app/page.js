import fs from 'node:fs';
import path from 'node:path';

function extractSection(html, tag) {
  const match = html.match(new RegExp(`<${tag}[^>]*>([\\s\\S]*?)</${tag}>`, 'i'));
  return match ? match[1].trim() : '';
}

const landingPageHtml = fs.readFileSync(path.join(process.cwd(), 'index.html'), 'utf8');
const landingPageStyles = extractSection(landingPageHtml, 'style');
const landingPageBody = extractSection(landingPageHtml, 'body');

export default function HomePage() {
  return (
    <>
      <style dangerouslySetInnerHTML={{ __html: landingPageStyles }} />
      <div dangerouslySetInnerHTML={{ __html: landingPageBody }} />
    </>
  );
}
