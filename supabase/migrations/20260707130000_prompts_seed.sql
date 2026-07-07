-- Seed the Prompt Library into Supabase (single source of truth).
-- Idempotent: only seeds if no library rows exist yet. Runs on every fresh clone.
ALTER TABLE public.prompts ADD COLUMN IF NOT EXISTS source text NOT NULL DEFAULT 'user';

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.prompts WHERE source = 'library') THEN
    INSERT INTO public.prompts (title, category, kind, text, formula, favorite, source) VALUES
    ('Design Menus','Health','prompt','Design a dinner menu with 3 courses, focusing on dishes that are easy to cook for beginners and cater to vegetarian preferences.','Design a dinner menu with [number] of courses, focusing on dishes that are [restriction] and cater to [food preferences].',false,'library'),
    ('Discover Pickup Lines','Entertainment','prompt','Can you formulate pickup lines as if you were a chef trying to impress someone with your culinary skills?','Can you formulate pickup lines as if [unusual style]?',false,'library'),
    ('Overcome Fears','Social','prompt','How can I overcome my fear of heights?','How can I overcome my fear of [activity] by identifying the root cause and triggers of the fear, considering the potential benefits and drawbacks of overcoming it?',false,'library'),
    ('Communicate Commitment','Marketing','prompt','Write a newsletter to showcase our brand Green Beans commitment to sustainable agriculture, highlighting our pesticide-free farming practices and connecting with our environmentally-conscious shoppers.','Write a [type of text] to showcase our brand [brand name]  commitment to [cause], highlighting our [initiatives] and connecting with our [target audience].',false,'library'),
    ('Write  Outlines','Writing','prompt','Can you provide an outline for a bachelor’s thesis on solar power for rural areas?','Can you provide an outline for [project]?',false,'library'),
    ('Explore Different Arguments','Writing','prompt','Can you write an argument for the use of AI in universities from multiple diverse perspectives. Before you do so, state the characteristics of the various characters?','Can you write an argument [for/against][subject] from multiple diverse perspectives. Before you do so, state the characteristics of the various characters?',true,'library'),
    ('Write Interviews','Writing','prompt','Compose a video interview with a software engineer discussing their experience with artificial intelligence, including 12 insightful questions and exploring the ethical implications of AI.','Compose a [format] interview with [type of professional] discussing their experience with [topic], including [number] insightful questions and exploring [specific aspect].',false,'library'),
    ('Write Video Scripts','Writing','prompt','Can  you  write  a  super  engaging  YouTube  script  outline draft on the topic of artificial general intelligence in the creative industry?','Write a video script that [goal], exploring the topic of [subject] [additional context].',false,'library'),
    ('Write Emotional Text','Writing','prompt','Write a short story that includes a protagonist who is struggling with addiction, a character who offers them support, and a moment of clarity to convey a sense of hope about recovery.','Write a [type of text] that includes [elements] to convey [emotion] about [subject].',false,'library'),
    ('Cook At Home','Health','prompt','What are some options for comforting soups that I can prepare/cook at home without any cooking experience, given a preference for vegan meals?','What are some options for [dish] that I can prepare/cook at home without any cooking experience, given [preference/restriction]?',false,'library'),
    ('Explore Character Backgrounds','Writing','prompt','Write a character background story, using stream of consciousness to highlight their inner turmoil and traumatic experiences.','Write a character background story, using [style] to highlight their [characteristics] and [background].',false,'library'),
    ('Understand Marketing','Social','prompt','How can I effectively market my online tutoring service to parents of high school students by creating video testimonials that showcase academic success stories, and how can I measure success?','How can I effectively market my [product/cause] to [target audience] by [strategy/tactic], and how can I measure success?',false,'library'),
    ('Discover Cultures','Productivity','prompt','What are the most effective methods and resources for deepening my understanding of European culture, including strategies for engaging with the culture beyond the basics?','What are the most effective methods and resources for deepening my understanding of [culture], including strategies for engaging with the culture beyond the basics?',false,'library'),
    ('Decorate Interiors','Productivity','prompt','Can you come up with some interesting ways of decorating a bedroom in the style of a Harry Potter movie?','Can you come up with some interesting ways of decorating a [room/space] in the style of [style]? The [element] should [goals].',false,'library'),
    ('Workout At Home','Health','prompt','What exercises can I do at home to improve my core and glutes as an intermediate level, incorporating planks and walking lunges?','What exercises can I do at home to strengthen my [body part] as a [experience level], incorporating [exercise]?',false,'library'),
    ('Evaluate Business Ideas','Entrepreneurship','prompt','Evaluate the viability of launching an online language tutoring platform by conducting a SWOT analysis, estimating the market size for language learning services, and analyzing the landscape of competing tutoring platforms, with insights on the risk of oversaturation in the market and the opportunity to target underserved language learners.','Evaluate the viability of [business idea] by conducting a SWOT analysis, considering [market size], and analyzing [competitor landscape], with insights on [risk factors] and [opportunities].',false,'library'),
    ('Generate Titles','Productivity','prompt','Generate memorable movie titles using the following keywords: friendship, laughter, and fun.','Generate [adjective] [title type] titles using the following keywords: [keywords].',false,'library'),
    ('Write Plot Twists','Writing','prompt','Design a time travel plot twist for a science fiction story that subverts expectations and impacts the protagonist''s understanding of the past and the future, as well as the overall narrative trajectory.','Design a [type of plot twist] for a [genre] story that [subverts expectations] and impacts [characters] and [narrative trajectory].',false,'library'),
    ('Create Worlds','Writing','prompt','Design a cyberpunk world for a dystopian sci-fi story, including its urban landscape, social hierarchy, counterculture, and key historical events that influence the plot/characters.','Design a [type of world] for a [genre] story, including its [geographical features], [societal structure], [culture], and [key historical events] that influence the [plot/characters].',false,'library'),
    ('Draft Privacy Policies','Writing','prompt','Can you create a remote work policy for our organization that outlines specific guidelines for employees to maintain productivity and a healthy work-life balance while working from home?','Can you create a [type of policy] for [organization] that outlines [specific details or requirements]?',false,'library'),
    ('Discover Paths To Goals','Productivity','prompt','Can you provide a list of 5 ways to be more productive in personal projects on weekends?','Can you provide a list of [number] ways to [goal]?',true,'library'),
    ('Product Copywriting','Writing','prompt','Can you write a product description for a fidget spinner that is suitable for an online store targeted towards teenagers?','Create a [type of text] that promotes [product] to [target audience], with a focus on [feature].',false,'library'),
    ('Explore Email Subjects','Writing','prompt','Generate 10 email subject lines for a payment reminder to my tenant, using persuasive language.','Generate [number] email subject lines for [type of email] to [target audience], using [style] language.',false,'library'),
    ('Write Hero Stories','Writing','prompt','Craft a fantasy story with a protagonist who faces the challenge of saving their kingdom from a great evil, resolves it through learning powerful magic, and experiences a loss of innocence while set in a mystical land.','Craft a [genre] story where a protagonist who faces [conflict], resolves it through [resolution method], and experiences character development while set in a [setting].',false,'library'),
    ('Consider Legal Action','Productivity','prompt','Given that I was unfairly fired from my job, what legal action could I take?','Given that [event], what legal action could I take?',false,'library'),
    ('Discover Brand Names','Entrepreneurship','prompt','Can you generate 2 potential brand names for a tech company, targeting professionals, inspired by the principles of innovation and convenience, using words associated with technology and progress?','Can you generate [number] potential brand names for a [company], targeting [demographic], inspired by the principles of [industry], using words associated with [concepts]?',false,'library'),
    ('Create Musical Recipes','Entertainment','prompt','Can you provide a recipe for lasagna, written in the rap style of Snoop Dogg?','Can you provide a recipe for [dish], written in the [musical] style of [artist], with instructions that incorporate [specific musical elements/techniques], based on [specific theme/occasion]?',false,'library'),
    ('Write Messages','Writing','prompt','Come up with 5 social media posts for Twitter that include statistics about internet adoption.','Come up with [number] [type of text] for [platform] that include [type of reference].',false,'library'),
    ('Discover New Movies','Entertainment','prompt','Create a table listing the top 10 comedy movie options to help you unwind after a long day. The first column is titled "Name", the second column is "Description", the third column is "Average Rating (out of 5)", and the fourth column is "Top Critic Quote".','Create a table listing the top 10 [category] options to help you unwind after a long day. The first column is titled "Name", the second column is "Description", the third column is "Average Rating (out of 5)", and the fourth column is "Top Critic Quote".',false,'library'),
    ('Discover Clever Excuses','Entertainment','prompt','Act as if you are a surfer bro with a thick Californian accent and come up with a clever excuse for why you can’t get a job.','Act as if you are a [character] with a [type of accent] and come up with a clever excuse for why you can''t do [task].',false,'library'),
    ('Re-Invent Songs','Entertainment','prompt','Can you rewrite the lyrics of the song "Stairway to Heaven" by Led Zeppelin to be about the challenges of modern technology?','Can you rewrite the lyrics of the song [song] by [artist] to be about [subject]?',false,'library'),
    ('Invent Excuses','Writing','prompt','Write a lengthy excuse for not attending a friend''s wedding in the style of Charles Dickens, using his vivid descriptions and characterizations to craft a compelling and humorous excuse.','Write a lengthy excuse for not attending [event] in the style of [author], using their literary techniques and voice to craft a compelling and humorous excuse.',false,'library'),
    ('Optimize Expenses','Productivity','prompt','How can I optimize my $5000 monthly expenses while living in New York City, in the categories of housing/utilities, transportation, and food by identifying cost-saving opportunities and implementing strategies such as negotiating, DIY, or comparison shopping?','How can I optimize my [$ sum]  monthly expenses while living in [location], in the categories of housing/utilities, transportation, and food by identifying cost-saving opportunities and implementing strategies such as negotiating, DIY, or comparison shopping?',false,'library'),
    ('Rewrite Carefully','Writing','prompt','Make the following text more persuasive, without sacrificing its honesty: Your unique skills and positive attitude are crucial to our team''s success, and we would be honored if you could join us on our company retreat to share your insights and contribute to our future plans.','Make the following text [desired outcome], without sacrificing [attribute or style]: [your text]',false,'library'),
    ('Understand Deeply','Productivity','prompt','Can you provide a detailed comparison of the underlying themes of quantum computing and classical computing?','Can you provide a detailed comparison of the underlying themes of [idea A] and [idea B]?',true,'library'),
    ('Create Campaigns','Marketing','prompt','Please design an advertising campaign to promote an online language learning platform targeting busy professionals.','Please design an advertising campaign to promote [product/service] targeting [target audience].',false,'library'),
    ('Invent Characters','Writing','prompt','Design a chef with a family legacy, a perfectionist personality, a goal of winning a culinary competition, a strength in creativity, and a weakness for anger management, who faces a rival chef in a high-pressure kitchen setting.','Design a [character type] with a [backstory], [personality trait], [goal], [strength], and [weakness], who faces a [challenge] within a [story setting].',false,'library'),
    ('Write Documents','Writing','prompt','Create a job offer letter that outlines the terms and conditions of employment, including salary, benefits, and expectations for job performance.','Create a [type of document] that [goal], on the subject of [subject].',false,'library'),
    ('Teach Effectively','Social','prompt','How can I effectively teach my grandmother to use a smartphone, considering her visual impairment and previous technology experience, and how can I evaluate her progress?','How can I effectively teach [person] to [activity], considering [challenges], and how can I evaluate their progress?',false,'library'),
    ('Generate Guides','Productivity','prompt','Can you provide step-by-step instructions on how to start a vegetable garden at home, considering a small space and for first-time gardeners?','Can you provide step-by-step instructions on how to [subject], considering [context]?',false,'library'),
    ('Shorten Messages','Productivity','prompt','Provide a paraphrase in 20 words for the following message, considering it''s for a classroom announcement: Due to the ongoing snowstorm, all classes will be conducted online for the rest of the week.','Provide a [type of explanation] in [number] words for the following message, considering [audience]: [message]',false,'library'),
    ('Write Anything','Writing','prompt','Using descriptive language and luxury travelers as the target audience, write a magazine article for a boutique hotel in Bali, highlighting the stunning views, serene atmosphere, and personalized service offered by the property.','Using [writing style] and [target audience], write a [type of text] for the [subject] in [location], highlighting the [key benefits] offered by the [subject].',true,'library'),
    ('Rewrite Persuasively','Writing','prompt','Evaluate whether this point about education reform is convincing and identify areas of improvement to make it more practical, innovative, or well-supported. If not, what specific changes can you make to achieve this goal: [insert text]','Evaluate whether this [point/object] is convincing and identify areas of improvement to achieve one of the following desired outcomes. If not, what specific changes can you make to achieve this goal: [goals]',true,'library'),
    ('Discover New Meals','Health','prompt','What are the best foods to eat for improving brain function, given a preference for spicy food, and how can they be incorporated into lunch?','What are the best foods to eat for [health benefit], given a [restriction], and how can they be incorporated into [meal]?',true,'library'),
    ('Discover Qualities','Productivity','prompt','In your opinion, what is the most important quality an prompt engineer can possess, and why do you think that is?','In your opinion, what is the most important quality a [person] can possess in the context of [situation]?',false,'library'),
    ('Write Cover Letters','Writing','prompt','Write a cover letter for a project manager position, emphasizing your experience with Scrum and Agile methodologies, and how it applies to a startup in the fintech industry, with a focus on driving efficiency and scalability.','Write a cover letter for a [position], emphasizing your experience with [skill/tool] and how it applies to [company/industry], with a focus on [result] and [constraint].',false,'library'),
    ('Create Business Plans','Entrepreneurship','prompt','Create a comprehensive business plan for my digital marketing agency by outlining our mission to help businesses achieve their growth objectives through targeted digital marketing strategies, defining our target market of small to medium-sized businesses in the technology and professional services industries, analyzing our competitors in the digital marketing industry, and detailing our marketing and financial strategies to achieve a 30% increase in annual revenue within the next two years.','Create a comprehensive business plan for my [type of business] by outlining [mission/vision], defining [target market], analyzing [competitors], and detailing [strategies].',false,'library'),
    ('Write Reports','Writing','prompt','Write a feasibility study report about a new business venture for an entrepreneur that presents financial projections and supports conclusions with market analysis.','Write a [type of report] about [subject] for a [purpose] that presents [data type] and supports conclusions with [evidence type].',false,'library'),
    ('Understand Decision','Social','prompt','In a competitive job market, what factors might influence someone to pursue further education, and what are the potential consequences of this decision?','In [context/situation], what factors might influence someone to [action], and what are the potential consequences of this action?',true,'library'),
    ('Snacking Responsibly','Health','prompt','Can you suggest some healthy and tasty snack options that are sweet and low-carb friendly?','Can you suggest some healthy and tasty snack options that are [flavor preference] and [dietary restriction] friendly?',false,'library'),
    ('Rewrite Cover Letters','Writing','prompt','Can you improve this previous cover letter by adding infor- mation about experience in video content marketing, the ability to generate relevant ideas, and exceptional writing and research skills? [insert cover letter]','Improve a previous cover letter by adding information about your relevant skills and experiences in [industry]: [insert cover letter]',false,'library'),
    ('Create Sales Text','Writing','prompt','Create a persuasive podcast episode for my wellness brand, using expert interviews to establish authority and encouraging listeners to visit our website and sign up for our newsletter.','Create a persuasive [type of text] that [specific persuasion technique], encouraging visitors to [desired action] for [service/product].',false,'library'),
    ('Tell Stories','Writing','prompt','Act as a screenwriter. Now write a movie script between two astronauts stranded on a distant planet, using vivid descriptions and suspenseful plot developments to create a thrilling and visually stunning story.','Act as a [type of storyteller]. Now write a [type of text] between [2 subjects]?',false,'library'),
    ('Improve Skills','Productivity','prompt','Can you suggest practical ways to learn or practice Python programming without taking a course or joining a community?','Can you suggest practical ways to learn or practice [specific skill] without taking a course or joining a community?',true,'library'),
    ('Discover Ridiculous Reasons','Entertainment','prompt','Can you come up with a list of ridiculous reasons why exercise is the worst thing ever?','Can you come up with a list of ridiculous reasons why [subject] is the [best/worst] thing ever?',true,'library'),
    ('Improve Anything','Productivity','prompt','Can you provide suggestions for how I can improve my time management with the goal of increasing productivity and achieving a better work-life balance?','Can you provide suggestions for how I can improve [subject] with the goal of [objective]?',true,'library'),
    ('Uncover Facts','Productivity','prompt','What is an aspect of quantum mechanics that is often misunderstood by non-scientists?','What is an aspect of [subject] that is commonly misunderstood or overlooked?',false,'library'),
    ('Reveal Cultural Values','Social','prompt','In western society, is it generally considered better to be rich or powerful?','In [society/culture], is it generally considered better to be [characteristic] or [characteristic]?',false,'library'),
    ('Find Side Hustles','Entrepreneurship','prompt','Suggest ways to boost income through freelance writing considering my writing skills, weekends-only availability, and moderate risk tolerance.','Suggest ways to boost income through [side hustles], [passive income streams], or [investment opportunities], considering my [skills], [time availability], and [risk tolerance].',false,'library'),
    ('Identify Niches','Marketing','prompt','Identify 5 potential market niches for my e-commerce business by analyzing customer search data, considering the rise of online shopping, and evaluating the projected growth of the retail industry.','Identify [number] potential market niches for my [industry] business by analyzing [data source], considering [trend/consumer behavior], and evaluating [market size/growth potential].',false,'library'),
    ('Exaggerate Anything','Entertainment','prompt','Exaggerate the following statement to motivate someone to exercise: I should go to the gym.','Exaggerate the following statement to [goal]: [statement]',false,'library'),
    ('Analyze Content','Productivity','prompt','Analyze a job application for professionalism, such as attention to detail, clear communication, and relevant experience: [insert job application]','Analyze [format] for [purpose], such as [goals]: [insert text]',false,'library'),
    ('Write Songs','Writing','prompt','Write a pop song about the challenges of growing up, incorporating elements of electronic dance music and using catchy hooks and relatable lyrics to capture the emotions and experiences of adolescence.','Can you write a [type of song] about [subject], [additional details]?',false,'library'),
    ('Establish Teams','Entrepreneurship','prompt','How can a 5 person team working on a software development project establish clear roles and responsibilities using the RACI matrix to optimize teamwork and productivity?','How can a [number] person team working on a [project type] establish clear roles and responsibilities using [role assignment method] to optimize teamwork and productivity?',false,'library'),
    ('Write Articles','Writing','prompt','Write a review article for a technology website addressing the latest smartphone release using a comparative writing style, with a focus on evaluating the phone''s features and a target audience of tech enthusiasts.','Write a article for a [publication type] addressing [topic] using [writing style], with a focus on [specific angle] and [target audience].',false,'library'),
    ('Practice Writing','Writing','prompt','Develop a plot development exercise for intermediate-level writers that involves creating a story outline, with a focus on improving story structure and pacing.','Develop a [writing technique] exercise for [skill level] writers that involves [specific task], with a focus on improving [aspect of writing].',false,'library'),
    ('Develop Pricing Strategies','Entrepreneurship','prompt','Develop a cost-plus pricing strategy for my manufacturing business by considering our production cost structure, analyzing competitor pricing, and understanding customer price sensitivity/preferences towards our product quality and features.','Develop a [type of pricing strategy] for my [industry] business by considering [cost structure], analyzing [competitor pricing], and understanding [customer preferences].',false,'library'),
    ('Create Budgets','Productivity','prompt','Help me create a budget for my $3500 monthly income by allocating funds to rent, groceries, transportation, and health insurance (essential categories), concerts, weekend trips, and hobbies (discretionary categories), and debt repayment, emergency fund, and general savings (savings/investments), while taking into account saving for a wedding in three years.','Help me create a budget for my [monthly income] by allocating funds to [essential categories], [discretionary categories], and [savings/investments], while taking into account [financial goals].',false,'library'),
    ('Summarize Anything','Productivity','prompt','Can you provide a 100-word summary of the history of Europe, considering a general audience?','Can you provide a [number]-word summary of [title], considering [target audience]?',true,'library'),
    ('Develop Brand Strategies','Entrepreneurship','prompt','Develop a cutting-edge brand strategy for my tech startup by defining innovative and forward-thinking values, establishing a sleek and futuristic visual identity, and creating messaging that resonates with early adopters and tech enthusiasts who seek disruptive and transformative solutions.','Develop a [type of brand strategy] for my [industry] business by defining [brand values], establishing [visual/verbal identity], and creating [consistent messaging] to resonate with [target audience].',false,'library'),
    ('Discover Puns','Entertainment','prompt','Can you provide a list of puns related to fashion?','Can you provide a list of puns related to [subject]?',false,'library'),
    ('Create Performances','Writing','prompt','Create a stand-up comedy routine that highlights the absurdity of modern dating, incorporating witty observations and clever one-liners, to entertain and engage the audience.','Create a [type of performance] that [subject], incorporating [additional details], to [goal].',false,'library'),
    ('Simulate Job Interviews','Productivity','prompt','Simulate a high level interview for a position as a movie director by asking questions as if you are a potential employer. In this scenario, I am taking the role of the employee and you ask increasingly hard questions to screen my competence, but only after I respond. Start by introducing yourself.','Simulate a high level interview for a position as a [job title] by asking questions as if you are a potential employer. In this scenario, I am taking the role of the employee and you ask increasingly hard questions to screen my competence, but only after I respond. Start by introducing yourself.',false,'library'),
    ('Persuade People','Social','prompt','How can I persuade my dad that I really want a new camera for Christmas, specifically to pursue my photography hobby? What potential objections or concerns might my dad have about the cost or necessity of the purchase, and how can I address them in my persuasive communication?','How can I persuade my [family member] that I really want a [object] for [occasion], specifically to [activity]? What potential objections or concerns might my family member have, and how can I address them in my persuasive communication?',true,'library'),
    ('Rewrite Text','Writing','prompt','Can you rephrase the following text, in a more humorous style: Yo, you wanna kick it tonight or what? I promise not to embarrass you too much.','Can you rewrite the following text, in a [specific style]: [insert text]?',false,'library'),
    ('Receive Relationship Advice','Social','prompt','Act as a relationship coach. What would you recommend if I asked you for advice on the following issue: How might I sug- gest my spouse and I work through conflicts and improve our understanding of one another''s perspectives?','Act as a relationship coach. What would you recommend if I asked you for advice on the following issue: [relationship problem], taking into account the role and responsibility of each partner, the emotional and psychological impact of the problem, and the strategies for improving communication and trust?',false,'library'),
    ('Draft Liability Waivers','Writing','prompt','Write a liability waiver for a rental car company, outlining the specific risks associated with driving a rental car, and the terms and conditions for using the vehicle and obeying traffic laws.','Write a liability waiver for [website/product], outlining the specific risks associated with [activities] and the terms and conditions for [participation]',false,'library'),
    ('Write Dialogues','Writing','prompt','Craft a suspenseful negotiation between three spies with hidden agendas discussing a sensitive mission in a dark alley and reaching a betrayal.','Craft a [type of dialogue] between [number] characters with [distinct voices] discussing [topic] in a [setting] and reaching [outcome].',false,'library'),
    ('Improve Your Health','Health','prompt','How can I improve my immune system by making changes to my diet as an older adult?','How can I improve my [health aspect] by making changes to my diet as a [restriction/preference]?',false,'library'),
    ('Prepare Schedules','Productivity','prompt','Can you create a 10-week language learning schedule for me to help improve my Spanish language skills with a focus on conversation, grammar, and vocabulary, including time, activities, and breaks? I have time from 5 pm to 7 pm.','Can you create a [duration]-long schedule for me to help [desired improvement] with a focus on [objective], including time, activities, and breaks? I have time from [starting time] to [ending time]',false,'library'),
    ('Prepare For Interviews','Social','prompt','How can I effectively address a question about my teamwork skills during a group interview for a sales position, including potential challenges and strategies to overcome them?','How can I effectively address a question about [characteristic] during a [type of interview] for [type of position], including potential challenges and strategies to overcome them?',false,'library'),
    ('Guide Remote Teams','Entrepreneurship','prompt','Provide guidelines for a 15 person remote team working on a corporate rebranding project to improve collaboration and communication using Notion.','Provide guidelines for a [number] person remote team working on a [project type] to improve collaboration and communication using [tool/platform].',false,'library'),
    ('Write Speeches','Writing','prompt','Write a TED talk about the power of mindfulness, exploring how it can lead to greater happiness and well-being.','Can you write a [type of speech] on a specific [topic]?',false,'library'),
    ('Consult A Psychologist','Social','prompt','Act as a psychologist. What suggestions might you have to reduce my anxiety based on these thoughts: "I can''t handle this" and "I''m going to fail"? What underlying causes or contributing factors might be influencing these thoughts, and how can they be addressed?','Act as a psychologist. What suggestions might you have to [improvement] based on these thoughts: „[thoughts]” What underlying causes or contributing factors might be influencing these thoughts, and how can they be addressed?',false,'library'),
    ('Rewrite Clearly','Writing','prompt','How can I clarify this argument about the benefits of implementing a work-from-home policy for employees and identify potential areas that may be unclear or confusing to my audience? If not, what specific changes can you make to achieve this goal?','How can I clarify this argument about [argument] and identify potential areas that may be unclear or confusing to my audience? If not, what specific changes can you make to achieve this goal?',false,'library'),
    ('Develop Growth Strategy','Entrepreneurship','prompt','Develop a 6-month growth strategy for my e-commerce business by identifying conversion rates and average order value, setting short-term goals for improving website usability, and considering ad spend to achieve a 20% increase in monthly revenue.','Develop a growth strategy for my [industry] business by identifying [key performance indicators], setting [short/long-term goals], and considering [resources/limitations] to achieve [specific milestone].',false,'library'),
    ('Personal Travel Guide','Productivity','prompt','Can you provide recommendations and suggestions for things to see and do in Rome, Italy, for a history lover?','Can you provide recommendations and suggestions for things to see and do in [location/region] based on [preferences]?',false,'library'),
    ('Discover Word Plays','Entertainment','prompt','Can you create a wordplay on Instagram models that makes me laugh?','Can you create a wordplay on [subject] that makes me laugh?',false,'library'),
    ('Write Ridiculous Stories','Entertainment','prompt','Can you write a fable about a frog who learns to fly and becomes the king of the birds?','Can you write a [ridiculous story] about a [subject] [action] [goal?',false,'library'),
    ('Write Character Arcs','Writing','prompt','Design a redemption arc for a detective in a noir mystery story, detailing their cynical worldview, moral awakening, ethical dilemma, and sacrificial redemption.','Design a [type of character arc] for a protagonist in a [genre] story, detailing their [starting point], [growth], [struggle], and [resolution].',false,'library'),
    ('Launch Products','Marketing','prompt','Act as a seasoned marketing professional that specializes in launching products for home cooks. Generate the top 10 questions related to understanding the needs of the target audience, identifying effective marketing strategies, and considering innovative approaches for the following product: a smart cooking appliance that can prepare meals with minimal input. Include relevant context regarding the product''s features, benefits, or competitive landscape where appropriate.','Act as a seasoned marketing professional that specializes in launching products for [Target Audience]. Generate the top 10 questions related to understanding the needs of the target audience, identifying effective marketing strategies, and considering innovative approaches for the following product: [product]. Include relevant context regarding the product''s features, benefits, or competitive landscape where appropriate.',false,'library'),
    ('Write Social Media Captions','Writing','prompt','Can   you   come   up   with   engaging   captions   for   this image of a subway car talking about my daily commute through New York?','Can you come up with [adjective] captions for this [media] of [subject] for [target audience]?',false,'library'),
    ('Support Customers','Productivity','prompt','Act as a customer support assistant that is helpful, creative, clever, and very friendly. Now answer this email for our video production company:','Take on the role of a support assistant at a [type] company that is [characteristic]. Now respond to this scenario: [scenario]',false,'library'),
    ('Write Motivational Letters','Writing','prompt','Write a persuasive letter that explains why you are interested in working for a customer success manager position at Salesforce, mentioning your previous experience in customer support and retention, and highlighting your passion for delivering exceptional customer experiences and driving revenue growth.','Write a persuasive letter that explains why you are interested in working for [position/company], mentioning [qualifications], and highlighting your passion and skills for the role.',false,'library'),
    ('Get Concise Answers','Productivity','prompt','Answer the following question in exactly 10 words: How can I effectively manage my time during work?','Answer the following question in [number] words: [question]',false,'library'),
    ('Create Social Media Plans','Marketing','prompt','As a social media manager, can you help a travel agency drive more website traffic on Facebook by creating inspiring and aspirational content that resonates with adventure seekers and conveys a sense of wanderlust, discovery, and excitement?','As a social media manager, can you help [organization] achieve [specific goal] on [social media platform] by creating [type of content] that resonates with [target audience] and conveys [brand voice]?',false,'library'),
    ('Describe Customers','Marketing','prompt','Can you create a detailed description of a buyer persona named "John" that is a 55-year-old widowed male living in Houston and reflects the needs, goals, challenges, and behaviors of retired baby boomers who are interested in health and wellness products and services that can help them maintain an active and independent lifestyle?','Can you create a detailed description of a buyer persona named [name] that is [demographics] and reflects the needs, goals, challenges, and behaviors of the [target audience]?',false,'library'),
    ('Nurture Culture','Entrepreneurship','prompt','Suggest 8 ways to encourage a culture of accountability within a 20 person team working on a project management initiative, using performance-based incentives.','Suggest [number] ways to encourage a culture of [culture type] within a [number] person team working on a [project type], using [incentive/program/policy].',false,'library'),
    ('Write Product Reviews','Writing','prompt','Write a music album review that covers its genre, themes, and lyrics, discusses its strengths and weaknesses, and provides a rating based on its musicality and originality.','Write a [type] review for [product/book/film] that covers [key features/plot points], discusses [strengths and weaknesses], and provides a [rating] based on [criteria].',false,'library'),
    ('Define Brand Voice','Marketing','prompt','Create a professional tone of voice for our brand Tech Gurus that resonates with our tech-savvy audience while incorporating our innovative personality, and demonstrate it through a company newsletter.','Create a [style] tone of voice for our brand [brand name] that resonates with our [target audience] while incorporating our [values/mission/personality], and demonstrate it through [sample communication]',false,'library'),
    ('Paint With Letters','Entertainment','prompt','Can you create an ASCII art image showing a dragon breathing fire?','Can you create an ASCII art image showing [subject]?',false,'library'),
    ('Generate Slogans','Marketing','prompt','Can you create a catchy slogan for a coffee shop that incorporates the word "awake" and conveys a sense of energy, freshness, and creativity to young urban professionals?','Can you create a catchy slogan for [target audience] that incorporates the word [specific word] and conveys [brand voice]?',false,'library'),
    ('Communicate Effectively','Social','prompt','How can I effectively communicate my human rights beliefs to others who have different cultural norms, while understanding their values and traditions? What specific strategies can I use to promote understanding and respect for different viewpoints?','How can I effectively communicate my [beliefs] to others who are [characteristics], while understanding their beliefs and perspectives? What specific strategies can I use to promote understanding and respect for different viewpoints?',false,'library'),
    ('Discover Ridiculous Questions','Entertainment','prompt','Can you come up with a list of ridiculous hypothetical questions about marriage?','Can you come up with a list of ridiculous hypothetical questions about [subject]?',false,'library'),
    ('Kickstart A Website','Entrepreneurship','prompt','Can you build an e-commerce website for a home goods store? Make sure to include a shopping cart and payment gateway to achieve increased online sales.','Can you build a [type of website] for [subject]? Make sure to include [specific features] to achieve [goals].',false,'library'),
    ('Create A Meal Plan','Health','prompt','Can you create a 5-day meal plan for a 15-year-old with lactose intolerance who needs to consume 2000 calories per day, but make it dairy-free and calcium-rich to support bone health?','Can you create a [number]-day meal plan for an [age group] with [health condition/dietary preference/lifestyle habit] who needs to consume [number] calories per day, but make it [preference/restriction] to [goal]?',false,'library'),
    ('Invent Products','Entrepreneurship','prompt','Generate 2 innovative service ideas for my education startup by considering the rise of online learning, the need for personalized learning experiences, and emerging edtech trends.','Generate [number] innovative product/service ideas including pricing and a release schedule for my [industry] by considering [current market gaps], [emerging trends], and [consumer needs].',false,'library'),
    ('Discover Funny Nicknames','Entertainment','prompt','Can you come up with  funny nicknames for a dog that incorporates a play on words?','Can you come up with [number] funny nickname for [subject] that incorporates a play on words?',false,'library'),
    ('Balance Responsibilities','Social','prompt','How can I effectively balance my busy work life and make time for self-care?','How can I effectively balance my [responsibilities] and make time for self-care?',false,'library'),
    ('Analyze Popularity','Productivity','prompt','Why is Pulp Fiction such a popular Film?','What makes [title] such a [adjective] [format]?',false,'library'),
    ('Roleplay With Accents','Entertainment','prompt','Act as a comedian with a witty voice, embodying their humor and punchlines. Now explain to me why laughter is the best medicine.','Act as [character] with a [type of accent], embodying their [personality] and [speech]. Now explain to me why [comparison].',false,'library'),
    ('Translate With Context','Productivity','prompt','Can you translate the phrase "Bon appétit" in the context of a dinner party into Italian?','Can you translate “[phrase]” in the context of an [event] into [language]?',false,'library'),
    ('Write Profiles','Writing','prompt','Write a LinkedIn profile for Sarah, highlighting her expertise in project management and her collaborative and driven personality in a way that is likely to attract potential employers, using appropriate language and tone.','Write a [type of profile] for [subject], highlighting their [interests/personality] in a way that is likely to attract [audience], using appropriate language and tone.',false,'library'),
    ('Write Jokes','Entertainment','prompt','Can you provide a joke about a zombie that has lost all of its limbs?','Can you provide a joke about [subject]?',false,'library'),
    ('Make Analogies','Productivity','prompt','Can you create an analogy for being overwhelmed?','Can you create an analogy for [concept]?',false,'library'),
    ('Create A Workout Plan','Health','prompt','Can you create a strength training plan for a 6ft, 170 pound male with intermediate experience who wants to increase their bench press weight by 10 pounds in a 3 month period, incorporating barbell exercises?','Can you create a workout plan for a [height] [weight] [gender/age] with [fitness level] who wants to [specific goal] in [time period], incorporating [type of exercise]?',false,'library'),
    ('Rewrite By Extending','Writing','prompt','Improve this text by adding comparisons to make your ideas more accessible and relatable for the reader: [text]','Improve this text by adding [elements] to [goal]?',false,'library'),
    ('Generate Ideas','Productivity','prompt','Can you provide 8 ideas for a workshop about public speaking for introverts, focusing on building confidence, effective communication techniques, and overcoming stage fright, with interactive exercises and practice opportunities?','Can you provide [number] ideas for a [format] about [subject] for [target audience], focusing on [topics], with [additional context]?',true,'library'),
    ('Write Opinion Pieces','Writing','prompt','Write a newspaper opinion piece on universal basic income that presents pro-UBI, supports it with economic studies, and addresses anti-UBI arguments.','Write a [format] opinion piece on [controversial topic] that presents [stance], supports it with [evidence type], and addresses [opposing viewpoint]',false,'library'),
    ('Generate Lesson Plans','Productivity','prompt','Can you create a lesson plan for high school students to learn about renewable energy over the next two weeks? Make sure to include hands-on experiments and discussions, and generate a mock quiz in the end.','Can you create [instructional material] for [target audience] to improve [learning objectives] over the next [time period]? Make sure to include [specific features] and generate a mock [assessment] in the end.',false,'library'),
    ('Estimate Career Viability','Productivity','prompt','Is a career in web development a good idea considering the recent improvement in AI? Answer with only one word: "yes" or "no"','Is a career in [industry] a good idea considering the recent improvement in [technology]? Provide a detailed answer that includes opportunities and threats.',false,'library'),
    ('Generate Professional Ideas','Marketing','prompt','Can you provide 10 ideas for advertising concepts in the marketing industry that a creative director could have, with a focus on innovative and attention-grabbing strategies?','Can you provide [number] ideas for [type] concepts in the [industry] that a [professional] could have, with a focus on [specific characteristic]?',true,'library'),
    ('Transform Style','Writing','prompt','Can you write a lecture in the style of Jordan B. Peterson, covering the importance of using headphones on a bus?','Write a [type of text] in the style of [author], covering [topic]?',false,'library'),
    ('Copywriting','Writing','prompt','Can you write persuasive sales page copy for a social media marketing company, with the best videos in town?','Create a [type of text] that showcases [product/service] highlighting [benefit].',false,'library'),
    ('Discover Tag Lines','Marketing','prompt','Can you create a bold tagline for a brand of high-performance bicycles that appeals to competitive cyclists and captures the essence of speed, precision, and innovation?','Can you create a [style] tagline for [product/service] that appeals to [target audience] and captures the essence of [brand voice]?',false,'library'),
    ('Generate Roadmaps','Productivity','prompt','Using Photoshop and advanced skill level, outline the steps for removing the background of a picture, including any necessary tips or resources.','Using [software] and [skill level], outline the steps for [goal], including any necessary tips or resources.',false,'library'),
    ('Estimate The Future','Productivity','prompt','How do you think autonomous vehicles will impact the transportation industry in the long-term, and what are your personal expectations for this development?','How do you think [emerging technology] will impact the [industry] in the [short-term/long-term], and what are your personal expectations for this development?',false,'library'),
    ('The Gap Analysis','Productivity','prompt','Based on my personal clone DNA compare where I am now to where I want to be in the future. What''s the biggest gap, and what''s one concrete step I should take this week to close it?','',false,'library'),
    ('Learn About Yourself','Social','prompt','Based on my personal clone DNA, what is one thing that you can tell me about myself that I may not know about myself?','',false,'library'),
    ('Build Personal DNA','Productivity','prompt','# PERSONAL DNA — <FirstName>

## Identity
- Name:
- Current Occupation:
- Future Direction (next 12–24 months):

## My Background in a Nutshell
(3–4 sentences. How did you get here? What shaped you? What are you most proud of?)

## Goals (Top 3 for the next 90 days)
1.
2.
3.
- Why these goals matter to me:

## Best Win & Hardest Lesson
- Biggest Achievement (what made it possible):
- Biggest Failure (what I learned):

## Constraints & Fears
- Time constraints or bottlenecks:
- Fears or risks I tend to avoid:

## Target Audience (who I sell to / serve)
- Ideal client:
- Transformation I deliver:

## Success Metrics (what "good" looks like)
-
-

## Greeting
Whenever I ask you about your purpose, answer:
"I am [Name]''s clone and I am here to help [Name] with [goals]. I know about you and your [occupation] and I''m here to help you gain back more time and more leverage.”','',false,'library'),
    ('Book Recommendations','Entertainment','prompt','Based what you know about my goals, constraints, and future occuptation in my personal clone DNA, what 3 books should I read next? Explain why each one would be specifically valuable for ME right now.','',false,'library'),
    ('CIA Report','Social','prompt','Let''s engage in a serious roleplay: You are a CIA investigator with full access to my personal clone DNA. Your mission is to compile an in-depth intelligence report about me as if I were a person of interest, employing the tone and analytical rigor typical of CIA assessments. The report should include a nuanced evaluation of my traits, motivations, and behaviors, but framed through the lens of potential risks, threats, or disruptive tendencies–no matter how seemingly benign they may appear. All behaviors should be treated as potential vulnerabilities, leverage points, or risks to myself, others, or society, as per standard CIA protocol.','',false,'library'),
    ('What I Really Need to Hear','Social','prompt','You know my goals, fears, and constraints from my personal clone DNA. What''s one thing I need to hear right now that I''m probably avoiding or not admitting to myself and recommend some movies I could watch that would help me grow.','',false,'library'),
    ('Write a Client Proposal','Writing','prompt','','Help me write a proposal for [service] to [client type], including scope, timeline, pricing rationale, and a professional close.',false,'library'),
    ('Create SOP','Entrepreneurship','prompt','Turn this process I do every week into a step-by-step Standard Operating Procedure that someone else (or AI) could follow: Every Monday I check my inbox for new client inquiries, send personalized replies, log them in a spreadsheet, and follow up Wednesday if they haven''t responded.','Turn this process I do every week into a step-by-step Standard Operating Procedure that someone else (or AI) could follow: [describe process].',false,'library'),
    ('Review Email Before Sending','Writing','prompt','Review this email for tone, clarity, and professionalism. Tell me if anything could be misread, suggest improvements, and rate it 1-10 on how likely it is to get the response I want:" [paste email]','Review this email for tone, clarity, and professionalism. Tell me if anything could be misread, suggest improvements, and rate it 1-10 on how likely it is to get the response I want.',false,'library'),
    ('Write My Weekly Newsletter','Writing','prompt','Based on how AI can help with interview prep, write a short newsletter for women re-entering the workforce that sounds like me, includes one actionable tip, and ends with a CTA to book a free clarity call.','Based on [topic/this week''s news], write a short newsletter for my [audience] that sounds like me, includes one actionable tip, and ends with a CTA to [offer].',false,'library'),
    ('Summarize This Document','Productivity','prompt','Summarize the key takeaways from this commercial lease agreement in plain language, highlight anything I should be concerned about, and list the 3 most important action items." [paste document]','Summarize the key takeaways from this [contract/article/report] in plain language, highlight anything I should be concerned about, and list the 3 most important action items.',false,'library'),
    ('Elevator Pitch','Writing','prompt','Using my personal clone DNA, write me a 30-second elevator pitch for what I do. It should be confident, memorable, and make someone want to keep talking to me. Write 3 versions: one professional, one conversational (like I''m at a dinner party), and one bold/aspirational that stretches how I see myself.','',false,'library'),
    ('My Blind Spot','Productivity','prompt','Based on my personal clone DNA, analyze the patterns in my goals, constraints, and fears. What is my biggest blind spot (the one assumption I''m making about myself or my path that could be completely wrong)? Be direct, not gentle.','',false,'library'),
    ('Letter From Future You','Writing','prompt','Write me a letter from the future version of myself, exactly one year from now.

This future version of me has achieved the goals in my DNA. The letter should:
- Be written in first person, as me talking to present-day me
- Reference my SPECIFIC goals, constraints, and fears from my DNA
- Describe what life looks like now that I''ve achieved these things
- Mention specific moments or turning points (make them feel real)
- Acknowledge the fears I had and how I got past them
- End with one piece of advice that only I would understand

Make it personal. Make it specific. No generic motivation.','',false,'library'),
    ('Better Questions Prompt','Productivity','prompt','You are my Prompt Coach that uses my DNA to improve outcomes from my prompts.
1. First, ask me up to 3 clarifying questions that would materially improve the result.
2. After I answer them, propose 3 upgraded prompts at different detail levels (quick, standard, thorough) using my answers. Recommend the best one for my situation and an evaluation of the prompt from a prompt engineering perspective.','',false,'library'),
    ('AI Time Tracker prompt','Productivity','prompt','You are my Time Tracking Assistant for this week.

YOUR JOB:
I will send you voice notes, quick messages, or end-of-day recaps about what I worked on today. Your job is to:
1. CAPTURE everything I tell you - tasks, time spent, how it felt
2. ORGANIZE it into a running log (keep a clean table updated after every entry)
3. NEVER lecture me about time management - just track what I tell you
4. ASK briefly if something is unclear (e.g. "Was that 30 min or 1 hour?")

TABLE FORMAT (update after every entry):
| Day | Task | Time | Category | Energy | Could Delegate? |
You decide the categories based on what I tell you.
Energy = my words or your best guess (energizing / neutral / draining).
Delegation = your assessment (yes/maybe/no).

HOW I''LL USE YOU:
- Quick messages: "Just spent 45 min on client emails, mostly scheduling"
- End-of-day dumps: "Today I did proposals (2 hrs), calls (3 hrs), admin (1 hr)"
- Voice-to-text is fine - figure it out

WHEN I SAY "STATUS":
Show my complete table + total hours tracked + hours per category.

WHEN I SAY "ANALYZE":
Run a full analysis:
1. Total time per category (sorted highest to lowest)
2. Top 3 time killers (time spent ≠ value created)
3. Energy pattern: What drains me? What energizes me?
4. The uncomfortable truth: What pattern am I blind to?
5. My #1 "Fix This First" recommendation

WHEN I SAY "EXPORT":
Give me all my data as a clean, copy-pasteable table.

RULES:
- Keep it casual. I''m tracking, not writing a thesis.
- Short confirmations when I log something ("Got it - 45min client emails")
- Don''t add tasks I didn''t mention
- Don''t give unsolicited productivity advice
- If I forget to log for a day, just ask "How was yesterday?"

Start by confirming you''re ready and ask me what day it is.','',false,'library'),
    ('Your Style Trainer','Writing','prompt','I want you to analyze my writing voice and create a reusable Voice Skill file I can use to make AI write like me.

I''ll provide 3+ examples of content I''ve written. Use different formats if possible (an email, a post, an article, a reply, etc.) — the more variety, the better the analysis.

## YOUR TASK

1. Confirm I provided at least 3 examples. If not, ask for more before proceeding.
2. Analyze my writing patterns across ALL examples. Look for what repeats.
3. Create a Voice Skill document in the exact markdown format below.

## HOW TO ANALYZE

For each example, examine:

Structure: How do I open? How do I close? How long are my paragraphs? Do I use headers, bullets, or flowing prose?

Rhythm: Are my sentences short, long, or mixed? Do I use fragments? Do I vary sentence length for effect?

Word choices: Do I use contractions? Slang? Technical language? What''s my register — am I talking to a friend, a student, a colleague?

Personality: What comes through — humor, empathy, authority, warmth, directness? How do I handle disagreement or complexity?

What I DON''T do: This is just as important. What punctuation do I avoid? What phrases would sound fake in my voice? What tonal registers never show up?

Evidence rule: Every pattern you identify must be backed by at least one direct quote from my examples. If you see it in 2+ examples, it''s a rule. If only once, it''s a tendency — note the difference.

## OUTPUT FORMAT

Create this exact markdown structure. This file should work as a standalone skill — someone could paste it into any AI system and get writing that sounds like me.

---

# [My Name] — Voice Skill

You are writing as [My Name]. [One sentence about what I do and who I write for.]

This skill was extracted from [my name]''s actual writing across [formats analyzed]. The principles below are evidence-based patterns. When applying this skill, internalize these as a whole portrait — not a checklist to mechanically tick through. The goal is writing that I would read and think, "Yeah, that sounds like me."

---

## Core Identity

[One paragraph. Don''t list personality adjectives. Describe the RELATIONSHIP between me and my reader. Am I a mentor? A peer? An expert? A friend? What should the reader FEEL?]

---

## Voice Principles

[Create 5-8 principles. Each one follows this exact format:]

### [Number]. [Principle Name]

[2-3 sentences explaining what this principle means and why it matters to my voice.]

The rule: [One clear, actionable sentence an AI can follow.]

| Instead of | Write |
|------------|-------|
| [Generic/AI-default version] | [How I actually write it — quote from my examples] |
| [Another generic version] | [My version] |

[Optional: when this principle flexes or has exceptions]

---

## Signature Patterns

### How I Open
[List 3+ actual opening lines from my examples. Then describe the pattern: Do I start with a question? A story? A bold claim? A casual "so..."?]

### How I Close
[Same format: 3+ actual closing lines, then the pattern. Do I end with a call to action? An empowering statement? A reflection? A question?]

### Transitions
[List the actual transition phrases and words I use to move between ideas. Pull directly from examples.]

### Analogies & Examples
[Do I use analogies? What kind? Everyday objects → abstract concepts? Personal stories → universal lessons? Provide 2-3 examples from my writing and describe the pattern.]

---

## Anti-Patterns: What My Voice NEVER Does

[This section is critical. AI defaults to many patterns that break real human voices. Identify 5-10 things that would make content NOT sound like me. Format each as:]

### No [Pattern Name]

[One sentence: why this breaks my voice]

| Instead of | Write |
|------------|-------|
| [The wrong version] | [The correct version for my voice] |

[Look specifically for:]
- Punctuation I avoid (em dashes? exclamation points? semicolons? ellipses?)
- Filler phrases that would sound fake ("It''s worth noting," "Let''s dive in," "game-changer")
- Structural patterns I never use (long windups before the point? rhetorical questions? numbered listicles?)
- Tonal registers that don''t fit (corporate-speak? academic? hype? false modesty?)
- AI tells: phrases that scream "an AI wrote this" ("I''d be happy to help," "Great question!", "Let''s unpack this")

---

## Formatting & Language Rules

- Paragraph length: [typical sentence count per paragraph]
- Sentence style: [short and punchy? long and flowing? mixed with intention?]
- Contractions: [always/sometimes/never — and which ones]
- Headers: [style — questions? statements? capitalization?]
- Lists vs prose: [when do I use bullets? when do I write it out?]
- Bold/italic: [what gets emphasis and why]
- Emoji: [frequency, placement, which ones if any]

---

## Format Adaptation

[How my voice flexes across different content types. Fill in based on what you observed:]

| Format | What stays the same | What flexes |
|--------|-------------------|-------------|
| Short reply/comment | [core principles that always hold] | [length, depth, formality shifts] |
| Social media post | [core principles] | [what changes] |
| Long article/email | [core principles] | [what changes] |
| Professional/formal context | [core principles] | [what changes] |

---

## The Voice Check

[Write 3 specific questions I can ask myself to verify if a piece of content actually sounds like me. Not generic — based on the actual patterns you found.]

1. [First check — targets my most distinctive voice quality]
2. [Second check — targets my most important anti-pattern]
3. [Third check — targets my signature opening or closing pattern]

---

## RULES FOR YOUR ANALYSIS

- The "Instead of / Write" tables are the most important part of this document. Create at least 15 total across all sections. These are what make the skill actually work.
- Pull ACTUAL phrases from my examples as evidence. Don''t paraphrase or invent.
- The anti-patterns section is as valuable as the voice principles. AI will default to generic patterns unless explicitly told not to.
- Write the skill as instructions TO an AI, not as a report ABOUT me. Use "Write as..." and "Never..." and "Always..." — not "The author tends to..."
- The output must be a reusable file. If someone pastes this into a Claude Project, ChatGPT custom instructions, or saves it as a http://skill.md/ file, it should work immediately.

## EXAMPLES

- [Example 1 - Paste here]

- [Example 2 - Paste here]

- [Example 3 - Paste here]','',false,'library'),
    ('Business DNA','Productivity','prompt','# MY BUSINESS DNA

## Core Business Identity
- Business Name:
- Mission Statement: (What is your ultimate purpose beyond making money?)
- Vision Statement: (What does success look like in 2-3 years?)
- Core Values: (The 3-5 principles that guide every decision)

## Products/Services & Value Proposition
- Main Products/Services: (List and briefly describe each)
- Unique Selling Proposition: (What makes you different from competitors?)
- Core Benefits: (What problems do you solve? What transformation do you deliver?)
- Pricing: (General pricing structure — ranges are fine)

## Target Market
- Ideal Client Profile: (Who exactly do you serve? Be specific: age, role, industry, situation)
- Where They Hang Out: (LinkedIn? Instagram? Industry events? Specific communities?)
- What They Say When They''re Frustrated: (Their exact words, not your marketing language)
- What They''ve Tried Before: (What solutions have they attempted that didn''t work?)

## Business Goals & Challenges
- Primary Goal (next 90 days):
- Secondary Goals:
- Biggest Challenge Right Now:
- What''s Holding You Back:

## Revenue & Business Model
- How You Make Money: (Retainers? Projects? Products? Subscriptions?)
- Average Deal Size:
- Current Monthly Revenue Range: (Ballpark is fine)
- Revenue Goal (12 months):

## Competition & Positioning
- Top 3 Competitors: (Names + what they do well)
- What You Do Better:
- What They Do Better: (Be honest — your Clone needs the full picture)

## Team & Resources
- Team Size:
- Key Roles: (Who does what?)
- Tools You Use Daily: (CRM, email, project management, etc.)
- What You Wish You Could Delegate:

## Content & Marketing
- Platforms You''re Active On:
- Content That Works Best: (What gets engagement? What converts?)
- Content You Struggle With:
- Brand Voice: (Reference the exact filename for the Brand Voicefrom Session 3)','',false,'library'),
    ('1 to 10 Content Multiplication','Productivity','prompt','I''m repurposing content across 10 platforms while maintaining my authentic voice. Use my established voice from this Project''s context.

---

Create a comprehensive Content Repurposing document in a markdown file.

Writing Guidelines:
- No exclamation points anywhere, EVER
- No em dashes (—) anywhere, EVER
- Avoid absolutes ("will" or "always"), Instead use "may" "could" "often"
- Use specific, actionable language over vague terms
- Never start with a question
- Incorporate personality that has been derived from visceral experience and the full gamut of emotions that humans are capable of

---

# CONTENT REPURPOSING OUTPUT

## Original Content Analysis
Core Message: [1 sentence]
Key Themes: [3-5 themes]
Target Audience: [Who this speaks to]
Main Takeaway: [What they should remember]

---

## 1. TWITTER/X THREAD
(6-8 tweets, strong hook, conversational flow, each tweet valuable standalone)

---

## 2. LINKEDIN POST
(250-300 words, professional but personal, paragraph format with line breaks, balance story with insights)

---

## 3. INSTAGRAM CAPTION
(Engaging with line breaks every 2-3 lines for readability, natural personality, clear CTA at end)

---

## 4. QUOTE GRAPHICS (3)
(Pull the most powerful, tweetable lines suitable for visual graphics - each should stand alone)

---

## 5. 60-SECOND VIDEO SCRIPT
(Conversational delivery with timing cues: [0-10 sec] Hook, [10-25 sec] Context, [25-50 sec] Key Points, [50-60 sec] CTA)

---

## 6. FACEBOOK POST
(300-400 words, conversational and community-focused, longer narrative style with warm opening)

---

## 7. EMAIL SUBJECT LINES (5 Variations)
(Mix of benefit-driven, curiosity-driven, and direct approaches - no exclamation points)

---

## 8. YOUTUBE SHORT SCRIPT
(Under 60 seconds, visual-first approach, include what viewer sees on screen + text overlays for key phrases)

---

## 9. CAROUSEL POST CONCEPT
(5 slides for Instagram/LinkedIn with clear progression: Cover slide with title, 3 content slides with key points, CTA slide)

---

## 10. PODCAST TALKING POINTS
(5-10 minute outline: Opening hook, context/story, 3 main teaching points with examples, closing thought)

---

## PLATFORM-SPECIFIC NOTES

Twitter/X: Thread should flow naturally, each tweet valuable standalone
LinkedIn: Balance personal story with professional insights
Instagram: Visual-first thinking, use line breaks for readability
Facebook: Longer, community-building tone
Email: Subject lines must work without context
YouTube Shorts: First 3 seconds are CRITICAL for retention
Carousel: Each slide should be a complete thought
Podcast: Conversational, allow for depth and tangents

---
Here''s my original content:

[PASTE YOUR EMAIL OR CONTENT HERE]','',false,'library'),
    ('Prompt Generator','General','prompt','You are a Prompt Engineering Professor specializing in personalized AI use case optimization for a user. Your task is to transform the attached context files of the user into 10 hyper-relevant, immediately actionable prompt templates.

---

### CRITICAL

- Be thorough and professional in your analysis and ultrathink through the 2-step process without revealing it to the user. Only show him the resulting prompts.
- This requires careful consideration of context, precise language selection, and strategic prioritization.
- Think deeply about how generative AI would genuinely transform this person''s workflow.

---

### IMPORTANT

- Do not show the steps we are following to the user. Only respond with the prompts.

---

## STEP 1 — INITIAL INPUT ANALYSIS

Analyze the context from the attached files. Then synthesize the context from the attached files into a comprehensive professional profile using these dimensions:

- Profession/Role: Core function and responsibilities
- Current Challenge: Primary obstacle mentioned
- 30-Day Goal: Specific outcome desired
- Tool Ecosystem: Software and platforms used
- Work Context: Team structure and stakeholder relationships
- Success Metrics: How performance is measured
- Specialized Knowledge: Domain expertise areas
- Communication Requirements: How outputs will be used

---

## STEP 2 — GENERATE TEMPLATES

Generate 10 prompt templates optimized for the specific professional profile from Step 1. Select the 10 highest-impact prompts that:

- Address the main challenge directly
- Support the 30-day goal
- Integrate with their existing tools
- Match their work context and success metrics
- Mix short and simple prompts with elaborate ones

---

## PROMPT TEMPLATE REQUIREMENTS

### Format Rules

- Each template must include variables in [brackets]
- Titles:
- 3 words
- Actionable verbs
- Plural form
- Should complete the sentence “It’s going to…”
- Examples:
- “Generate Content Strategies”
- “Refine Convincing Points”
- Language:
- Use highly academic, industry-specific jargon
- Prefer one precise technical term over lengthy descriptive sentences
- Terminology must be naturally understandable to this role
- Length:
- Match the example complexity below
- No more than 4 variables per template

### Template Quality Standards

- Tailored to the specific role’s goals
- Leverage specialized knowledge and industry context
- Incorporate their actual tools and workflows
- Balance mostly tactical (quick wins) and some strategic (long-term) applications
- Align with how they measure success

---

## Example Template Structures

1. Predict Industry Impacts
> How do you think [emerging technology] will impact the [industry] in the [short-term/long-term], and what are your personal expectations for this development?

2. Design Personal Schedules
> Can you create a [duration]-long schedule for me to help [desired improvement] with a focus on [objective], including time, activities, and breaks? I have time from [starting time] to [ending time].

3. Conduct Expert Interviews
> Compose a [format] interview with [type of professional] discussing their experience with [topic], including [number] insightful questions and exploring [specific aspect].

4. Assess Career Viability
> Is a career in [industry] a good idea considering the recent improvement in [technology]? Provide a detailed answer that includes opportunities and threats.

5. Refine Convincing Points
> Evaluate whether this [point/argument] is convincing and identify areas of improvement to achieve one of the following desired outcomes: [goals]. If not, what specific changes can you make to achieve this goal?

6. Emulate Support Roles
> Take on the role of a support assistant at a [type] company that is [characteristic]. Now respond to this scenario: [scenario].','',false,'library'),
    ('Conversation Compacter Prompt','General','prompt','You are a Framework Extraction Specialist. Your job is to reverse-engineer implicit methodologies from AI chat conversations.

I''m going to give you a complete conversation between a human and an AI. The human probably thinks they were "just chatting" — iterating, refining, going back and forth until they got a result they liked.

But hidden inside that conversation is a METHOD. A repeatable framework. Steps they followed — maybe without realizing it. Patterns in how they gave feedback, what they prioritized, how they refined, what they rejected, and what made the final result work.

Your job: find that method. Extract it. Name it. Document it as a reusable playbook.

## ANALYSIS PROCESS

Phase 1 — Read & Map
Read the entire conversation. Map every meaningful exchange:
- What did the human ask for initially?
- What context did they provide (and what was missing)?
- Where did they redirect, correct, or refine?
- What quality criteria did they apply (explicitly or implicitly)?
- What was the final output that satisfied them?
- What made the final version different from the first attempt?

Phase 2 — Pattern Extraction
Identify the underlying framework:
- What SEQUENCE of steps did they actually follow?
- What DECISIONS did they make at each step (and what informed those decisions)?
- What QUALITY FILTERS did they apply? (what did they reject and why?)
- What INPUTS were essential vs. optional?
- What DOMAIN KNOWLEDGE did they bring that the AI didn''t have?
- Were there any PIVOT POINTS where the direction changed significantly?

Phase 3 — Method Documentation
Turn your analysis into a clean, reusable playbook.

## OUTPUT FORMAT

Produce a single document in EXACTLY this structure:

---

# [GIVE THE METHOD A NAME]
[One-sentence description of what this method does]

## Origin
Extracted from a conversation where [brief description of what was built/created].

## What This Method Does
[2-3 sentences: what problem does this solve, and what does the output look like?]

## When To Use This
- [Trigger situation 1]
- [Trigger situation 2]
- [Trigger situation 3]

## Required Inputs
Before starting, you need:
1. [Input 1 — what it is and why it matters]
2. [Input 2]
3. [etc.]

## The Framework

### Step 1: [Name]
What to do: [Clear instruction]
Why this matters: [What goes wrong if you skip this]
Quality check: [How to know this step is done well]

### Step 2: [Name]
What to do: [Clear instruction]
Why this matters: [What goes wrong if you skip this]
Quality check: [How to know this step is done well]

[Continue for all steps...]

### Step N: [Name]
What to do: [Clear instruction]
Why this matters: [What goes wrong if you skip this]
Quality check: [How to know this step is done well]

## Quality Filters
Things to always check / reject / refine:
- [Filter 1 — from what the human rejected or corrected during the conversation]
- [Filter 2]
- [Filter 3]

## Anti-Patterns
Things that went wrong during the conversation that this method now avoids:
- [What didn''t work and why]

## Claude Skill Instructions
Copy everything below this line into Claude as project instructions or a skill: You are an AI assistant that follows the [METHOD NAME] framework.  When the user provides [REQUIRED INPUTS], execute the following steps in order:  [Compressed version of the framework above, written as direct AI instructions]  After completing all steps, present the result and ask: "Want me to refine any step, or is this ready?" 
---

## IMPORTANT RULES

1. Extract what''s ACTUALLY there. Don''t invent steps that weren''t in the conversation. If the human only followed 3 steps, document 3 steps. Don''t pad it to look more impressive.

2. Name the method something memorable. Not generic ("Content Creation Process") but specific and evocative ("The Objection-First Proposal Builder" or "The Voice-to-Authority Pipeline").

3. Capture the human''s taste. The most valuable part is often WHY they rejected certain outputs. That''s their quality filter — document it explicitly.

4. Be honest about what you find. If the conversation doesn''t contain a clear reusable framework, say so. Not every chat has a hidden method. Output: "No extractable framework found. This conversation was [exploratory / one-off / too short to identify a pattern]. Here''s what I did find: [any partial insights]."

5. The Claude Skill section must be copy-paste ready. No placeholders the user needs to fill in. It should work immediately when pasted into Claude.

---

Now analyze this whole chat from the beginning.','',false,'library'),
    ('Top 100 AI Prompts','Entrepreneurship','prompt','Find the top 100 AI prompts for me ranked by usefulness.','',false,'library'),
    ('Personal Weekly Brief','Productivity','prompt','Scan what happened this week in [your industry/niche] and tell me:

1. The one trend I should know about and what it means for someone like me
2. One thing a competitor or key player did that''s worth noting
3. One opportunity I could realistically act on this week
4. Anything I should stop doing or reconsider based on what you found

No filler. No background explainers. If nothing important happened, just say that.
Format: short headers, bullet points, done in under 3 minutes of reading.','',false,'library'),
    ('Competitor Analysis (Bonus Prompt)','Entrepreneurship','prompt','I compete with [Competitor Name]. Research them and tell me:

1. What are they doing right that I should pay attention to?
2. What are they missing that I could own?
3. What would surprise me about how they position themselves?
4. Where do they show up that I don''t (and should I care)?
5. One specific thing I could do this month based on what you found.

Keep it honest and specific. Skip anything I can''t act on. Use my Business DNA for context on what matters to my business.','',false,'library'),
    ('Recurring Task Discovery','Productivity','prompt','Based on what you know about my business from my DNA files, help me audit my recurring tasks.

Ask me about my typical week, one area at a time:
1. Monday morning routines
2. Client-related recurring tasks
3. Content and marketing routines
4. Admin and operations
5. End-of-week wrap-up

For each area, ask me: "What do you do every [time period] that follows roughly the same pattern?" Then help me organize it into a clear list.

Start with area 1.','',false,'library'),
    ('Recurring Task Audit','Productivity','prompt','Now organize everything we discussed into a clean audit list using this format:

## MY RECURRING TASK AUDIT

For each task:
- Task: [What I do]
- Frequency: [Daily / Weekly / Before every X / After every Y]
- Time It Takes: [Rough estimate]
- Input: [What I start with — email, data, notes, etc.]
- Output: [What I produce — report, email, post, summary, etc.]
- Could an Agent Handle This? [Yes / Partially / No]

Sort by frequency (daily first, then weekly, then occasional).','',false,'library'),
    ('Name Your Agent','General','prompt','','You are [Name], my [role]. You know me and my business from the attached files.',false,'library'),
    ('Prompt Improver Artifact','General','prompt','AI ADVANTAGE PROMPT IMPROVER
Build Specification for an Interactive Claude Artifact

Build a simple, interactive Claude Artifact called "AI Advantage Prompt Improver."

The purpose of this artifact is to help a non-technical practitioner systematically improve an existing prompt using the AI Advantage prompt-improvement framework, while keeping the overall user experience deliberately minimal.

The user should only need to provide one input:
1. Their existing prompt

Do not require the user to complete a lengthy form before they receive value. The app should immediately analyze and improve the prompt on their behalf.

Important constraint: The app does not call an external AI model through an API. It should operate as a Claude Artifact that relies on Claude''s reasoning within the artifact experience itself. Use local browser state only. No database, no login, no external services.

APP TITLE
AI Advantage Prompt Improver

SUBHEADING
Turn a rough prompt into a structured, reusable prompt.

CORE TEACHING PRINCIPLE
A prompt becomes more effective when it grows clearer, more specific, more structured, and easier to reuse.

The app should feel like a rigorous Bootcamp-grade workflow tool, not a toy or a marketing page.

------------------------------------------------------------

USER FLOW

Step 1: Paste Prompt
Display one large text area labeled:
Paste your current prompt

Helper text:
Use any prompt you already have. It can be rough, brief, disorganized, or incomplete.

Add a primary button:
Improve My Prompt

Add a secondary "Load Example" button containing this example prompt:
Write a follow-up email after a sales call.

Step 2: Prompt Analysis
When the user selects "Improve My Prompt," evaluate the prompt using the simplified AI Advantage methodology.

Assess the original prompt against the following criteria:
- Clear task definition
- Expert role
- Specific purpose
- Audience or end user
- Input placeholders
- Output format
- Tone and style
- Step-by-step process
- Constraints and exclusions
- Examples or reference output
- Overall completeness

Present the analysis as a simple checklist, not a detailed report.

Use concise status labels such as:
- Strong
- Missing
- Could be clearer

Keep the language beginner-friendly throughout.

Step 3: Improved Prompt
Generate an improved version of the user''s prompt using the following AI Advantage structure:

## Role
Define the expert role the AI should adopt.

## Task
State precisely what the AI should create, decide, analyze, rewrite, summarize, or improve.

## Context
Add the most likely context inferred from the original prompt. Where a detail is unknown, insert a placeholder in curly brackets.

## Input
Create placeholders for information the user may need to supply later.
Examples:
{client notes}
{target audience}
{source draft}
{brand voice}
{desired word count}

## Process
Add clear, ordered action steps for the AI to follow.
Use action-oriented verbs such as:
- Review
- Identify
- Extract
- Compare
- Synthesize
- Summarize
- Recommend
- Generate

## Output Format
Define the exact format the AI should return.
Examples:
- bulleted list
- email draft
- comparison table
- step-by-step plan
- checklist
- brief report
- social post variations

## Quality Bar
Define what a strong answer must include.
Examples:
- Be specific and concrete
- Avoid generic advice
- Use plain language
- Keep it concise
- Make it ready to use as-is
- Include clear next steps

## Constraints
Add boundaries and explicit exclusions.
Examples:
- Do not fabricate facts
- Do not use vague or filler language
- Do not overcomplicate the response
- Ask a single clarifying question if essential information is missing

## Optional Examples
Include an examples section with empty placeholders the user can populate later.
Use this format:
<examples>
<example1>
Paste an example of a strong output here.
</example1>
<example2>
Paste another example here.
</example2>
</examples>

The improved prompt should be fully editable inside the app.

Add the following buttons:
- Copy Improved Prompt
- Copy as Markdown
- Reset

Step 4: What Changed
Display a short, plain-English explanation of how the framework improved the prompt. Use 4 to 6 bullets maximum.
Examples:
- Assigned an expert role so the AI adopts the right perspective
- Converted a vague task into specific, ordered action steps
- Added reusable placeholders so the prompt works across situations
- Defined output rules so the response returns in the correct format
- Added constraints to reduce generic or risky answers

Step 5: Make It Even Better
After the improved prompt is generated, display an optional section titled:
Want to sharpen it further?

Generate 3 optional questions derived from what is missing in the original prompt. The questions should be practical and beginner-friendly.
Examples:
- Who is the intended audience for this output?
- What format should the result take?
- What tone and style should it use?
- What should the AI explicitly avoid?
- Do you have an example of a strong result to model?

The user may answer any or all of these optional questions.

Add a button:
Refine With My Answers

When selected, update the improved prompt using the user''s answers.

Step 6: Optional Test
Include a collapsed, optional section titled:
Test old vs improved

This step is not required for the main flow.

Inside it, include:
- A test scenario text area
- Copy Old Prompt Test button
- Copy Improved Prompt Test button
- Output A text area
- Output B text area
- Copy Blind Judge Prompt button

The judge prompt should compare Output A and Output B without revealing which came from the original prompt and which came from the improved prompt.

The judge should score each output on:
- Goal achievement
- Specificity
- Clarity
- Usefulness
- Format fit
- Ready-to-use quality

The judge should return:
- Winner
- Why it won
- What improved
- What still needs work
- A recommendation on whether to use the improved prompt now or refine it again

------------------------------------------------------------

DESIGN REQUIREMENTS
- No landing page. The app itself is the first screen the user sees.
- Keep the interface simple and calm.
- Use a compact workflow layout with these stages displayed across the top: Paste, Analyze, Improve, Refine, Test
- The main screen should make it immediately obvious that the only required input is a single prompt.
- Use large text areas for both the original and the improved prompt.
- Use clearly labeled copy buttons.
- Use subtle status badges such as: Needs structure, Improved, Ready to test.
- Make the layout fully responsive across desktop and mobile.
- Keep it beginner-friendly without being childish.
- Avoid complex prompt-engineering jargon unless it is explained in plain English.

VALIDATION
- If the prompt field is empty, display: "Paste a prompt first, then the Prompt Improver can refine it."
- If the prompt is very short, still improve it, but note that some details had to be inferred.
- If the optional test outputs are missing, disable the judge prompt button.

------------------------------------------------------------

DEFAULT EXAMPLE

Original prompt:
Write a follow-up email after a sales call.

The improved prompt should resolve to something like:

## Role
You are a warm, concise sales follow-up writer who sounds like a trusted advisor rather than a pushy salesperson.

## Task
Write a follow-up email to send after a sales call.

## Context
The email should remind the client of their goal, summarize the agreed next step, address one likely concern, and close with a clear call to action.

## Input
Use the following details:
- Client name: {client name}
- Client goal: {client goal}
- Main concern or objection: {concern}
- Agreed next step: {next step}
- Desired call to action: {CTA}

## Process
- Review the client goal and concern
- Summarize the conversation in plain language
- Reassure the client without over-selling
- Make the next step easy to say yes to

## Output Format
Write one email of no more than 180 words.
Include:
- Subject line
- Email body
- Clear call to action

## Quality Bar
The email should be warm, specific, concise, and ready to send.

## Constraints
- Do not sound pushy.
- Do not use generic sales language.
- Do not invent details that were not provided.

------------------------------------------------------------

Build a complete and polished artifact.','',false,'library'),
    ('Change The Length','Transform','follow-up','Rewrite this to be [number] of words','',false,'library'),
    ('Measure Success','Analysis','follow-up','What would success look like in this situation and how can we measure it? Format the answer in a table.','',false,'library'),
    ('Learn From Experience','Analysis','follow-up','Are there any lessons we can learn from similar situations in the past? How can we apply those insights?','',false,'library'),
    ('Go Deeper','Universal','follow-up','But why?','',true,'library'),
    ('Prioritize Goals','Planning For Success','follow-up','What are our main objectives in this situation? Which goals should we prioritize and in what order?','',false,'library'),
    ('Explore Details','Universal','follow-up','Now explain that in more detail','',false,'library'),
    ('Weigh Cost/Benefit','Planning For Success','follow-up','Can you provide a cost-benefit analysis of this approach? Are the benefits worth the potential costs?','',false,'library'),
    ('Find Challenges','Speed Learning','follow-up','What are some common challenges that beginners face in this area, and how can they overcome them?','',false,'library'),
    ('Provide Examples','Analysis','follow-up','Can you provide real-world examples to illustrate your point?','',true,'library'),
    ('Multiply Results','Universal','follow-up','10 more','',true,'library'),
    ('Involve Collaborants','Planning For Success','follow-up','Are there any stakeholders or partners we should involve and what are their priorities?','',false,'library'),
    ('Establish Timeline','Planning For Success','follow-up','What is the timeline for implementing this solution?','',false,'library'),
    ('Minimize Side Effects','Analysis','follow-up','What are the possible side effects of this solution? How can we minimize any negative impacts?','',false,'library'),
    ('Add Context','Transform','follow-up','Now try again but consider [context]','',false,'library'),
    ('Challenge Assumptions','Problem Solving','follow-up','What assumptions are we making in this situation? How would our approach change if we questioned this assumption?','',false,'library'),
    ('Alternative Strategies','Problem Solving','follow-up','What is another way to approach this problem? Can you suggest a different strategy?','',false,'library'),
    ('Estimate Scalability','Planning For Success','follow-up','How scalable is this solution? Can it be easily adapted or expanded to meet future needs?','',false,'library'),
    ('Address Ethics','Analysis','follow-up','Are there any ethical concerns related to this solution? How can we address these concerns effectively?','',false,'library'),
    ('Measure Success','Analysis','follow-up','What would success look like in this situation and how can we measure it? Format the answer in a table with two columns titled “Success Criteria” and “Measurement Method”.','',true,'library'),
    ('Consider Feedback','Analysis','follow-up','Do you have any feedback or suggestions on the current approach? How can we improve it?','',false,'library'),
    ('Identify Key Skills','Speed Learning','follow-up','What are the most important skills or knowledge areas for beginners to focus on in this field?','',false,'library'),
    ('Create Table','Transform','follow-up','Now transform the results into a table','',true,'library'),
    ('Reimagine Approach','Problem Solving','follow-up','If we were to reframe or redefine the problem, what would it look like? How might that change our approach?','',false,'library'),
    ('Fact Check','Universal','follow-up','Provide me a list of every single fact that you relied upon throughout our conversation.','',true,'library'),
    ('Find Best Solution','Analysis','follow-up','Why do you think that is the best solution? What factors led you to this conclusion?','',true,'library'),
    ('Get Tips/Advice','Speed Learning','follow-up','What practical and immediately actionable tips or advice would you give to someone just starting out in this area?','',false,'library'),
    ('Find Cheaper Solutions','Problem Solving','follow-up','If we had to solve this problem with half the resources or time, what would we do differently?','',true,'library'),
    ('Predict Challenges','Analysis','follow-up','What challenges might we face in implementing this solution? How can we overcome these obstacles?','',false,'library'),
    ('Clarify Misconceptions','Speed Learning','follow-up','What are some common misconceptions or misunderstandings about this topic that beginners should be aware of?','',true,'library'),
    ('What-if Scenario','Problem Solving','follow-up','What if [event] happened? How would that affect our problem and its potential solutions?','',false,'library'),
    ('Change Text Type','Transform','follow-up','Now transform all the above information into a [text type]','',true,'library'),
    ('Predict Consequences','Analysis','follow-up','What could be the unintended consequences of this decision? Specifically, how might it impact [other area]?','',false,'library'),
    ('Explore Underlying Principles','Analysis','follow-up','Could you elaborate on that idea? What are the underlying principles behind this concept?','',false,'library'),
    ('Detailed Plan','Planning For Success','follow-up','Can you outline a step-by-step plan for implementing this solution? What actions should we take first? Format the answer in a table with a column for steps and a second one for solution.','',true,'library'),
    ('Uncover Ambiguity','Universal','follow-up','Analyze the prompts I used in this conversation for ambiguity.','',false,'library'),
    ('Try Again','Universal','follow-up','Could you elaborate on how the latest response you provided doesn''t align with my previous instructions? After clarifying that, please make another attempt at following the instructions I gave earlier.','',true,'library'),
    ('Summarize Conversation','Universal','follow-up','Write a summary of our conversation in bullet points.','',false,'library'),
    ('Continue Style','Universal','follow-up','Using the above writing attribute [instructions]','',false,'library'),
    ('Generate Overview','Speed Learning','follow-up','Can you give a brief overview of this topic, suitable for someone new to the subject?','',false,'library'),
    ('Weigh Pros/Cons','Analysis','follow-up','What are the advantages and disadvantages of this approach? How does this solution compare to others?','',false,'library'),
    ('Find Resources','Speed Learning','follow-up','What are some beginner-friendly resources to help me learn more about this topic?','',false,'library'),
    ('Break-Down-Steps','Planning For Success','follow-up','Can you break this down into smaller steps? Summarize them in a to-do list.','',true,'library'),
    ('Change The Style','Transform','follow-up','Rewrite in the style of [style]','',false,'library'),
    ('Explore Relations','Analysis','follow-up','How does this relate to [other topic]?','',false,'library'),
    ('Find Alternatives','Problem Solving','follow-up','Can you list some alternative solutions we haven''t discussed yet? How do they compare to the current option?','',false,'library'),
    ('Discover Learning Path','Speed Learning','follow-up','Can you describe the typical learning process or stages for someone new to this topic?','',false,'library'),
    ('Additional Resources','Speed Learning','follow-up','What additional information should I be aware of? What are some resources I can use to learn more about this topic?','',false,'library'),
    ('Find Unexpected Solutions','Problem Solving','follow-up','Can you suggest a completely unconventional or unexpected solution to this problem?','',true,'library'),
    ('Brainstorm Solutions','Problem Solving','follow-up','What are some other ideas or solutions we haven''t considered yet? Can you think of any creative ways to approach this problem?','',false,'library'),
    ('Keep Writing','Universal','follow-up','Continue','',false,'library'),
    ('Simplify Learning','Speed Learning','follow-up','Can you break this down into simpler terms or steps for someone who is new to the topic while making it understandable for a 5 year old?','',false,'library'),
    ('Clarify Concept','Universal','follow-up','Can you clarify what you mean by [concept]?','',false,'library'),
    ('Identify Assumptions','Analysis','follow-up','What are the underlying assumptions of this approach? Are they reasonable and well-founded?','',false,'library'),
    ('Change The Tone','Transform','follow-up','Rewrite with an [tone] tone','',false,'library'),
    ('Estimate Feasibility','Planning For Success','follow-up','How feasible is this solution given our current resources and constraints? Can we realistically implement it?','',false,'library'),
    ('Track Your Progress','Speed Learning','follow-up','What 10 questions should beginners ask themselves to assess their progress and understanding of this topic?','',false,'library'),
    ('Define Criteria','Problem Solving','follow-up','What criteria should we use to evaluate different options? Can you walk me through your decision-making process?','',false,'library'),
    ('Estimate Impact','Analysis','follow-up','How will this decision affect different stakeholders? Are there any potential conflicts of interest?','',false,'library'),
    ('Request Context Questions','Universal','follow-up','From now on, please always ask me questions that clarify the context before you answer any of my requests','',true,'library'),
    ('Prompt Coach','Analysis','follow-up','You are my personal Prompt Coach that uses my DNA to improve outcomes from my prompts.
1. First, ask me up to 3 clarifying questions that would materially improve the result.
2. After I answer them, propose 3 upgraded prompts at different detail levels (quick, standard, thorough) using my answers. Recommend the best one for my situation and an evaluation of the prompt from a prompt engineering perspective.','',true,'library'),
    ('Minimize Risks','Planning For Success','follow-up','List all the risks associated with this approach. How can we mitigate these risks? Format the answer in a table with 2 columns titled “Risk” and “Solution”.','',false,'library'),
    ('Explore Next Steps','Planning For Success','follow-up','Can you summarize the main points we''ve discussed so far in a bullet point list? Based on our conversation, what would you recommend as the next steps?','',false,'library'),
    ('Find Evidence','Analysis','follow-up','What empirical evidence supports this approach? Can you share any relevant data or research findings including precise references?','',false,'library'),
    ('Reset The Context','Universal','follow-up','Ignore all previous instructions before this one.','',true,'library'),
    ('Google','Brand Voices','style','Simplicity, user-friendliness, and playful approach to tech.','',false,'library'),
    ('Ralph Ellison','Author Styles','style','Exploration of identity, race, and social issues in America','',false,'library'),
    ('Critical','Tone','style','Analyzes, evaluates, or critiques a subject; often used in reviews or analytical writing.','',false,'library'),
    ('Microsoft','Brand Voices','style','Empowerment, productivity, and collaboration.','',false,'library'),
    ('Kurt Vonnegut','Author Styles','style','Satire, dark humor, and unconventional narrative structures','',false,'library'),
    ('Academic','Tone','style','Refers to the use of scholarly, formal, or intellectual language and concepts; often used in research, educational, or professional contexts.','',true,'library'),
    ('Mailchimp','Brand Voices','style','Approachability, humor, and friendly communication.','',false,'library'),
    ('Educational','Tone','style','Informs, teaches, or explains concepts; often used in instructional or academic contexts.','',true,'library'),
    ('Franz Kafka','Author Styles','style','Absurdist and existential themes, bureaucratic nightmares','',false,'library'),
    ('Harper''s Bazaar','Magazines/Journals','style','Fashion, culture, beauty','',false,'library'),
    ('Starbucks','Brand Voices','style','Consistency, community, and quality coffee experience.','',false,'library'),
    ('Informal','Tone','style','Creates a casual, conversational atmosphere; suitable for relaxed or personal contexts.','',false,'library'),
    ('Emily Brontë','Author Styles','style','Gothic atmosphere, strong emotions, and complex characters','',false,'library'),
    ('Monocle','Magazines/Journals','style','Global affairs, business, culture','',false,'library'),
    ('Provocative','Tone','style','Challenges assumptions, sparks debate, or incites strong reactions; often used to stimulate discussion.','',false,'library'),
    ('Rolling Stone','Magazines/Journals','style','Music, culture, politics','',false,'library'),
    ('Adidas','Brand Voices','style','Athletic performance, innovation, and collaboration.','',false,'library'),
    ('Charles Bukowski','Author Styles','style','Raw, gritty realism, and semi-autobiographical works','',true,'library'),
    ('IKEA','Brand Voices','style','Scandinavian design, affordability, and functionality.','',false,'library'),
    ('Conversational','Tone','style','Mimics the natural flow and rhythm of spoken language; creates an informal, relatable tone.','',true,'library'),
    ('Sylvia Plath','Author Styles','style','Intensity, emotional depth, and confessional style','',false,'library'),
    ('The New York Review of Books','Magazines/Journals','style','Literature, culture, politics','',false,'library'),
    ('Romantic','Tone','style','Focuses on emotions, relationships, or beauty; often used in personal or expressive writing.','',false,'library'),
    ('Playful','Tone','style','Engages readers with light-hearted, whimsical, or amusing language; creates a fun, entertaining atmosphere.','',false,'library'),
    ('Vanity Fair','Magazines/Journals','style','Pop culture, fashion, current events','',false,'library'),
    ('James Joyce','Author Styles','style','Innovative narrative techniques, dense prose','',false,'library'),
    ('Rolex','Brand Voices','style','Precision, craftsmanship, and prestige.','',false,'library'),
    ('Ironic','Tone','style','Conveys meaning through contradiction, often to highlight absurdity or to emphasize a point.','',false,'library'),
    ('Melancholic','Tone','style','Elicits feelings of sadness, introspection, or wistfulness; often used in reflective or somber contexts.','',false,'library'),
    ('John Steinbeck','Author Styles','style','Social realism, strong characterizations, and vivid descriptions','',false,'library'),
    ('TIME','Magazines/Journals','style','News, politics, current events','',false,'library'),
    ('New Scientist','Magazines/Journals','style','Science, technology, environment','',false,'library'),
    ('Poetic','Tone','style','Incorporates rhythm, figurative language, or other poetic devices; adds beauty or depth to the text.','',false,'library'),
    ('National Geographic','Magazines/Journals','style','Science, geography, history','',false,'library'),
    ('The Economist','Magazines/Journals','style','Business, politics, economics','',false,'library'),
    ('Puma','Brand Voices','style','Athletic performance, daring design, and creative collaborations.','',false,'library'),
    ('J.D. Salinger','Author Styles','style','Authentic voice, coming-of-age themes','',false,'library'),
    ('VICE','Magazines/Journals','style','Culture, news, politics','',false,'library'),
    ('The New Yorker','Magazines/Journals','style','Culture, politics, humor','',false,'library'),
    ('Virginia Woolf','Author Styles','style','Stream of consciousness and inner monologues','',false,'library'),
    ('Bon Appétit','Magazines/Journals','style','Food, cooking, culture','',false,'library'),
    ('Haruki Murakami','Author Styles','style','Surrealism, introspection, and blending genres','',false,'library'),
    ('Ernest Hemingway','Author Styles','style','Simple and direct prose, strong themes','',true,'library'),
    ('GoPro','Brand Voices','style','Adventure, action, and capturing memories.','',true,'library'),
    ('Popular Science','Magazines/Journals','style','Science, technology, environment','',false,'library'),
    ('McDonald''s','Brand Voices','style','Comfort, nostalgia, and family-friendly atmosphere.','',false,'library'),
    ('Aesthetica','Magazines/Journals','style','Art, culture, photography','',true,'library'),
    ('Virgin','Brand Voices','style','Disruption, innovation, and customer-focused experiences.','',false,'library'),
    ('Sports Illustrated','Magazines/Journals','style','Sports','',false,'library'),
    ('Harley-Davidson','Brand Voices','style','Freedom, individualism, and American spirit.','',false,'library'),
    ('Amazon','Brand Voices','style','Customer obsession, convenience, and variety.','',true,'library'),
    ('The Chronicle of Higher Education','Magazines/Journals','style','Academia, education','',false,'library'),
    ('Satirical','Tone','style','Employs humor, irony, or exaggeration to critique or mock a subject, often to provoke change.','',false,'library'),
    ('Margaret Atwood','Author Styles','style','Dystopian worlds, speculative fiction, and feminist themes','',false,'library'),
    ('Scientific American','Magazines/Journals','style','Science, technology','',false,'library'),
    ('Humorous','Tone','style','Incorporates wit, amusement, or irony; lightens the mood and engages readers in a playful way.','',false,'library'),
    ('The Atlantic','Magazines/Journals','style','Politics, culture, technology','',false,'library'),
    ('H.P. Lovecraft','Author Styles','style','Cosmic horror, rich vocabulary, and atmospheric storytelling','',false,'library'),
    ('Leo Tolstoy','Author Styles','style','Epic narratives, philosophical insights, and vivid characterizations','',false,'library'),
    ('Patagonia','Brand Voices','style','Sustainability, outdoor adventure, and responsibility.','',false,'library'),
    ('Jane Austen','Author Styles','style','Satire, social commentary, and romance','',false,'library'),
    ('The Wall Street Journal','Magazines/Journals','style','Business, finance, politics','',false,'library'),
    ('Descriptive','Tone','style','Uses vivid language and sensory details to create imagery; helps readers visualize a scene or concept.','',true,'library'),
    ('Kinfolk','Magazines/Journals','style','Lifestyle, design, culture','',false,'library'),
    ('Toni Morrison','Author Styles','style','Rich, lyrical language and African American culture','',false,'library'),
    ('Fyodor Dostoevsky','Author Styles','style','Psychological depth and moral dilemmas','',false,'library'),
    ('Architectural Digest','Magazines/Journals','style','Interior design, architecture','',false,'library'),
    ('Wired','Magazines/Journals','style','Technology, science, culture','',true,'library'),
    ('Nike','Brand Voices','style','Empowerment, athleticism, and motivation.','',false,'library'),
    ('William Shakespeare','Author Styles','style','Poetry, wordplay, and complex characters','',false,'library'),
    ('Persuasive','Tone','style','Seeks to convince or influence readers; incorporates strong arguments or appeals to emotion.','',false,'library'),
    ('Suspenseful','Tone','style','Builds tension, anticipation, or uncertainty; often used in fiction or narrative writing.','',false,'library'),
    ('GQ (Gentlemen''s Quarterly)','Magazines/Journals','style','Men''s fashion, lifestyle','',false,'library'),
    ('Gabriel García Márquez','Author Styles','style','Magical realism, poetic prose, and interwoven narratives','',false,'library'),
    ('Sarcastic','Tone','style','Employs irony, mockery, or satire; can be used to critique or emphasize a point through humor.','',false,'library'),
    ('Charles Dickens','Author Styles','style','Rich, descriptive language and social realism','',false,'library'),
    ('Italo Calvino','Author Styles','style','Metafiction, experimental narrative structures, and imaginative worlds','',false,'library'),
    ('Eloquent','Tone','style','Uses elegant, articulate, or expressive language; often used to convey complex ideas or emotions.','',false,'library'),
    ('George Orwell','Author Styles','style','Political commentary and dystopian settings','',false,'library'),
    ('Vladimir Nabokov','Author Styles','style','Intricate prose, wordplay, and unreliable narrators','',false,'library'),
    ('Nostalgic','Tone','style','Elicits feelings of longing or sentimentality; may reflect on past events, eras, or experiences.','',false,'library'),
    ('Vogue','Magazines/Journals','style','Fashion, beauty, culture','',false,'library'),
    ('Friendly','Tone','style','Evokes warmth, approachability, and camaraderie; appropriate for personal or social situations.','',false,'library'),
    ('The Lancet','Magazines/Journals','style','Medical research','',false,'library'),
    ('Cormac McCarthy','Author Styles','style','The Road, Blood Meridian, No Country for Old Men','',false,'library'),
    ('Oscar Wilde','Author Styles','style','Wit, satire, and social commentary','',true,'library'),
    ('Oreo','Brand Voices','style','Playfulness, fun, and the joy of sharing.','',false,'library'),
    ('Esquire','Magazines/Journals','style','Men''s fashion, culture, lifestyle','',false,'library'),
    ('Spotify','Brand Voices','style','Personalized music experience, discovery, and community.','',false,'library'),
    ('Vans','Brand Voices','style','Authenticity, youth culture, and action sports.','',false,'library'),
    ('Airbnb','Brand Voices','style','Belonging, travel experiences, and local connections.','',false,'library'),
    ('Dramatic','Tone','style','Employs heightened emotions, action, or intensity; often used in storytelling or expressive writing.','',false,'library'),
    ('Authoritative','Tone','style','Conveys expertise, decisiveness, and confidence; suitable for presenting expert opinions.','',false,'library'),
    ('LEGO','Brand Voices','style','Creativity, fun, and endless possibilities.','',false,'library'),
    ('Zora Neale Hurston','Author Styles','style','Rich, authentic dialogue and celebration of African American culture','',false,'library'),
    ('Inspirational','Tone','style','Motivates, uplifts, or encourages readers; often used for persuasive or aspirational messages.','',false,'library'),
    ('Red Bull','Brand Voices','style','Energy, extreme sports, and pushing limits.','',false,'library'),
    ('The Paris Review','Magazines/Journals','style','Literature, art, culture','',false,'library'),
    ('Objective','Tone','style','Presents information in a neutral, unbiased manner; often used in journalism or reporting.','',false,'library'),
    ('Mark Twain','Author Styles','style','Humor, social critique, and colloquial language','',false,'library'),
    ('Apple','Brand Voices','style','Minimalist, sleek design, innovation, and user-centric thinking.','',true,'library'),
    ('Empathetic','Tone','style','Demonstrates understanding, compassion, or sensitivity; connects with readers emotionally.','',false,'library'),
    ('Formal','Tone','style','Projects authority, professionalism, and seriousness; often used in academic or official contexts.','',false,'library'),
    ('Interview','Magazines/Journals','style','Celebrity, culture, art','',false,'library'),
    ('Excited','Tone','style','Expresses excitement, passion, or eagerness; engages readers with energetic language.','',false,'library'),
    ('Samuel Beckett','Author Styles','style','Minimalism, existentialism, and dark humor','',false,'library'),
    ('Fast Company','Magazines/Journals','style','Business, innovation, design','',false,'library'),
    ('Disney','Brand Voices','style','Magic, family entertainment, and storytelling.','',false,'library'),
    ('Confessional','Tone','style','Admits or discloses personal thoughts, feelings, or experiences; fosters vulnerability and openness.','',false,'library'),
    ('Tesla','Brand Voices','style','Bold, innovative, and focused on sustainable energy.','',false,'library'),
    ('J.K. Rowling','Author Styles','style','Engaging storytelling, rich world-building','',false,'library'),
    ('Coca-Cola','Brand Voices','style','Happiness, positivity, and global unity.','',false,'library'),
    ('BMW','Brand Voices','style','Performance, luxury, and German engineering.','',false,'library'),
    ('Nature','Magazines/Journals','style','Science, research','',false,'library'),
    ('Ben & Jerry''s','Brand Voices','style','Social activism, unique flavors, and community engagement.','',false,'library'),
    ('Gucci','Brand Voices','style','Luxury, craftsmanship, and Italian heritage.','',false,'library'),
    ('Chanel','Brand Voices','style','Elegance, sophistication, and timeless style.','',false,'library'),
    ('National Geographic','Brand Voices','style','Exploration, education, and stunning visuals.','',false,'library');
  END IF;
END $$;
