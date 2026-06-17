GlobalVoiceLines.AresInstaKillVoiceLines =
{
	{
		BreakIfPlayed = true,
		RandomRemaining = true,
		SuccessiveChanceToPlay = 0.5,
		Source = { LineHistoryName = "NPC_Ares_01", SubtitleColor = Color.AresVoice },
		Cooldowns =
		{
			{ Name = "AresInstantKillSpeech", Time = 20 },
		},

		{ Cue = "/VO/Ares_0114", Text = "How sensible." },
		{ Cue = "/VO/Ares_0115", Text = "Oh truly?" },
		{ Cue = "/VO/Ares_0116", Text = "{#Emph}Ah. {#Prev}Very good." },
		{ Cue = "/VO/Ares_0117", Text = "Most intriguing." },
		{ Cue = "/VO/Ares_0118", Text = "How diplomatic.", PlayFirst = true },
		{ Cue = "/VO/Ares_0119", Text = "A clever move.", PlayFirst = true },
	},
}