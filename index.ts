// ============================================================
// WorkLink Edge Function: AI Profile Generator (PRD §6)
// Generates: professional summary, skill description,
// recommended market rate, strengths, suggested improvements.
// Deploy: supabase functions deploy generate-profile
// Secrets: supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
// ============================================================

import { createClient } from "npm:@supabase/supabase-js@2";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

Deno.serve(async (req) => {
  try {
    const authHeader = req.headers.get("Authorization") ?? "";
    const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

    // Identify the calling user from their JWT
    const { data: userData, error: userErr } = await createClient(
      SUPABASE_URL,
      Deno.env.get("SUPABASE_ANON_KEY")!,
      { global: { headers: { Authorization: authHeader } } },
    ).auth.getUser();
    if (userErr || !userData.user) {
      return json({ error: "Unauthorized" }, 401);
    }
    const workerId = userData.user.id;

    // Pull the worker's data
    const { data: worker } = await supabase
      .from("workers")
      .select("*, profiles!inner(full_name, town, preferred_language), worker_skills(skills(name))")
      .eq("id", workerId)
      .single();
    if (!worker) return json({ error: "Worker profile not found" }, 404);

    const skills = (worker.worker_skills ?? [])
      .map((ws: { skills: { name: string } }) => ws.skills.name)
      .join(", ");

    const prompt = `You are writing a profile for a worker on WorkLink, a Zambian
marketplace for informal workers. Respond ONLY with JSON, no markdown fences:
{
  "bio": "2-3 sentence professional summary, warm and concrete, third person",
  "skill_description": "1 sentence on their core skill",
  "recommended_daily_rate_zmw": <number>,
  "strengths": ["...", "..."],
  "improvements": ["...", "..."]
}

Worker:
- Name: ${worker.profiles.full_name}
- Town: ${worker.profiles.town ?? "Zambia"}
- Skills: ${skills || "General labour"}
- Years of experience: ${worker.years_experience}
- Jobs completed on platform: ${worker.jobs_completed}
- Current rating: ${worker.rating_avg} (${worker.rating_count} ratings)
- Current daily rate: ZMW ${worker.daily_rate_zmw ?? "not set"}

Rates should reflect the Zambian informal labour market for this trade and
experience level. Keep language simple and dignified.`;

    const aiRes = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
      },
      body: JSON.stringify({
        model: "claude-sonnet-4-6",
        max_tokens: 600,
        messages: [{ role: "user", content: prompt }],
      }),
    });
    const aiData = await aiRes.json();
    const text = (aiData.content ?? [])
      .filter((b: { type: string }) => b.type === "text")
      .map((b: { text: string }) => b.text)
      .join("");
    const parsed = JSON.parse(text.replace(/```json|```/g, "").trim());

    // Persist the generated bio
    await supabase.from("workers").update({ bio: parsed.bio }).eq("id", workerId);

    return json(parsed, 200);
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});

function json(body: unknown, status: number) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json" },
  });
}
