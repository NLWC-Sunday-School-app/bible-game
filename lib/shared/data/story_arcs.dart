class StoryArcsData {
  static const List<Map<String, dynamic>> arcs = [
    // =========================================================
    // ARC 1: THE EXODUS — FROM SLAVERY TO THE PROMISED LAND
    // =========================================================
    {
      'id': 'exodus_journey',
      'title': 'The Exodus Journey',
      'description':
          'Experience the epic story of Israel — from slavery in Egypt, through Moses\' calling, the ten plagues, the parting of the Red Sea, to the wilderness journey toward the Promised Land.',
      'chapters': [
        {
          'id': 'slavery_and_birth',
          'title': 'Slavery in Egypt and Moses\' Birth',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text': 'The descendants of Jacob had gone down to Egypt during the time of Joseph and had grown into a mighty nation. A new Pharaoh arose who did not know Joseph and feared the growing Israelite population. He enslaved them, forcing them to build great cities like Pithom and Rameses under brutal conditions.',
              'speaker': 'Narrator',
            },
            {
              'text': 'When slavery was not enough to slow their growth, Pharaoh issued a terrible decree: every Hebrew baby boy was to be thrown into the Nile River. One brave Levite mother, Jochebed, could not bear to obey. She hid her infant son for three months, then made a watertight basket from bulrushes and placed him in the reeds at the river\'s edge.',
              'speaker': 'Narrator',
            },
            {
              'text': 'The baby\'s sister Miriam watched from a distance. When Pharaoh\'s daughter came to bathe and discovered the basket, her heart was moved with compassion. Miriam cleverly offered to find a Hebrew woman to nurse the baby — and brought the baby\'s own mother. So Jochebed nursed her own son, paid by Pharaoh\'s household.',
              'speaker': 'Narrator',
            },
            {
              'text': 'When the child was old enough, he was brought to Pharaoh\'s daughter who adopted him as her own son. She named him Moses, meaning "drawn out of the water." Little did she know that this baby, drawn from the Nile, would one day draw all of Israel out of Egypt.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Approximately how long were the Israelites in Egypt?',
              'options': ['100 years', '200 years', '400 to 430 years', '600 years'],
              'answer': '400 to 430 years',
              'explanation': 'God told Abraham his descendants would be strangers in a land for 400 years; Exodus 12:40 records the stay as 430 years.',
              'bibleReference': 'Genesis 15:13, Exodus 12:40',
            },
            {
              'question': 'Why did Pharaoh begin to fear the Israelites in Egypt?',
              'options': ['They had built a large army', 'They were becoming too numerous and powerful', 'They refused to pay taxes', 'They had taken Egyptian land'],
              'answer': 'They were becoming too numerous and powerful',
              'explanation': 'A new Pharaoh feared the Israelites had become so numerous that in a war they might join Egypt\'s enemies and fight against Egypt.',
              'bibleReference': 'Exodus 1:9-10',
            },
            {
              'question': 'What did Pharaoh order done to all Hebrew baby boys?',
              'options': ['They were to be sold as slaves', 'They were to be taken from their mothers', 'They were to be thrown into the Nile River', 'They were to be sent to the desert'],
              'answer': 'They were to be thrown into the Nile River',
              'explanation': 'Pharaoh commanded all his people that every Hebrew son born must be thrown into the Nile, though daughters could live.',
              'bibleReference': 'Exodus 1:22',
            },
            {
              'question': 'What was the name of Moses\' mother?',
              'options': ['Miriam', 'Deborah', 'Jochebed', 'Zipporah'],
              'answer': 'Jochebed',
              'explanation': 'Moses\' mother was Jochebed, a daughter of Levi, who hid her son for three months before placing him in the basket.',
              'bibleReference': 'Exodus 6:20',
            },
            {
              'question': 'What was baby Moses placed in to float on the Nile?',
              'options': ['A wooden boat', 'A clay jar', 'A basket made from bulrushes', 'A woven blanket'],
              'answer': 'A basket made from bulrushes',
              'explanation': 'Jochebed made a basket from papyrus reeds (bulrushes), coated it with tar and pitch to make it waterproof, and placed baby Moses in it.',
              'bibleReference': 'Exodus 2:3',
            },
            {
              'question': 'Who watched over baby Moses\' basket in the reeds of the Nile?',
              'options': ['His mother Jochebed', 'His brother Aaron', 'His sister Miriam', 'A family servant'],
              'answer': 'His sister Miriam',
              'explanation': 'Moses\' sister stood at a distance to see what would happen to her baby brother in the basket among the reeds.',
              'bibleReference': 'Exodus 2:4',
            },
            {
              'question': 'Who discovered the basket containing baby Moses?',
              'options': ['A Hebrew midwife', 'Pharaoh\'s daughter', 'An Egyptian soldier', 'A Levite woman'],
              'answer': 'Pharaoh\'s daughter',
              'explanation': 'Pharaoh\'s daughter came to the Nile to bathe, saw the basket among the reeds, and when she opened it she saw the baby crying and felt sorry for him.',
              'bibleReference': 'Exodus 2:5-6',
            },
            {
              'question': 'Who nursed baby Moses after he was rescued from the Nile?',
              'options': ['Pharaoh\'s daughter herself', 'An Egyptian noblewoman', 'His own mother Jochebed', 'A Hebrew midwife'],
              'answer': 'His own mother Jochebed',
              'explanation': 'Through Miriam\'s clever suggestion, Pharaoh\'s daughter hired a Hebrew nurse who was actually Moses\' own mother, so she nursed her own son.',
              'bibleReference': 'Exodus 2:8-9',
            },
            {
              'question': 'What does the name Moses mean?',
              'options': ['Deliverer of Israel', 'God has heard', 'Drawn out of the water', 'Child of the Nile'],
              'answer': 'Drawn out of the water',
              'explanation': 'Pharaoh\'s daughter gave him the name Moses saying, "I drew him out of the water" — the name reflecting the miraculous circumstances of his rescue.',
              'bibleReference': 'Exodus 2:10',
            },
            {
              'question': 'Who were Moses\' brother and sister?',
              'options': ['Caleb and Deborah', 'Joshua and Rahab', 'Aaron and Miriam', 'Levi and Leah'],
              'answer': 'Aaron and Miriam',
              'explanation': 'Moses\' older brother was Aaron, who would become his spokesman, and his older sister was Miriam, who watched over him as a baby.',
              'bibleReference': 'Exodus 4:14, Exodus 15:20',
            },
          ],
        },
        {
          'id': 'burning_bush',
          'title': 'The Burning Bush',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'Moses had fled Egypt forty years earlier after killing an Egyptian who was beating a Hebrew slave. He settled in the land of Midian, married Zipporah, and became a shepherd for his father-in-law Jethro. Far from the palaces of Egypt where he had been raised, Moses now lived a quiet, humble life tending flocks among the desert hills.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'One day, while leading the flock to the far side of the wilderness, Moses came to Horeb — the mountain of God. There he saw an astonishing sight: a bush that was on fire, yet was not burning up. Curious, Moses turned aside to investigate this strange phenomenon, and as he drew near, a voice called out from within the flames: "Moses! Moses!"',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'God revealed Himself as the God of Abraham, Isaac, and Jacob, and told Moses to remove his sandals, for he was standing on holy ground. He had heard the cries of His people suffering in Egypt and had chosen Moses to go to Pharaoh and lead the Israelites out of slavery. Moses was overwhelmed and afraid, protesting that he was not capable of such a task.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'God patiently answered every objection Moses raised. When Moses asked God\'s name, God replied: "I AM WHO I AM." When Moses said he was not eloquent, God appointed his brother Aaron to be his spokesman. God showed Moses signs — turning his staff into a snake and making his hand leprous and whole again — to convince Pharaoh and the Israelites that the Lord had truly sent him.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question':
                  'How many years had Moses been living in Midian before the burning bush encounter?',
              'options': ['20 years', '30 years', '40 years', '50 years'],
              'answer': '40 years',
              'explanation':
                  'Moses fled Egypt at age 40 and spent 40 years in Midian as a shepherd before God appeared to him at the burning bush, making him 80 years old at the time of his call.',
              'bibleReference': 'Acts 7:30, Exodus 7:7',
            },
            {
              'question':
                  'What is the name of the mountain where Moses encountered the burning bush?',
              'options': [
                'Mount Sinai',
                'Mount Carmel',
                'Mount Horeb',
                'Mount Nebo',
              ],
              'answer': 'Mount Horeb',
              'explanation':
                  'The burning bush appeared to Moses at Horeb, the mountain of God. Horeb and Sinai are different names used in Scripture for the same sacred mountain.',
              'bibleReference': 'Exodus 3:1',
            },
            {
              'question': 'What was remarkable about the burning bush?',
              'options': [
                'It produced no smoke',
                'It was not consumed by the fire',
                'It glowed with seven colors',
                'It grew taller as Moses watched',
              ],
              'answer': 'It was not consumed by the fire',
              'explanation':
                  'Moses noticed that although the bush was on fire, it did not burn up. This miraculous sign drew his attention and led him to approach, where God spoke to him.',
              'bibleReference': 'Exodus 3:2-3',
            },
            {
              'question': 'What was Moses doing when he first saw the burning bush?',
              'options': [
                'Drawing water from a well',
                'Praying on a hillside',
                'Tending his father-in-law\'s flock',
                'Traveling to a nearby city',
              ],
              'answer': 'Tending his father-in-law\'s flock',
              'explanation':
                  'Moses was shepherding the flock of his father-in-law Jethro (also called Reuel) when he led the flock to the far side of the wilderness and came to Horeb.',
              'bibleReference': 'Exodus 3:1',
            },
            {
              'question': 'What name did God give Himself when Moses asked?',
              'options': [
                'The Lord of Hosts',
                'I AM WHO I AM',
                'The Almighty God',
                'The God of Heaven',
              ],
              'answer': 'I AM WHO I AM',
              'explanation':
                  'When Moses asked for God\'s name to tell the Israelites, God replied "I AM WHO I AM," and said to tell them "I AM has sent me to you." This reveals God\'s eternal, self-existent nature.',
              'bibleReference': 'Exodus 3:14',
            },
            {
              'question':
                  'What excuse did Moses give for not being able to speak to Pharaoh?',
              'options': [
                'He did not know the Egyptian language',
                'He was too young and inexperienced',
                'He was not eloquent and was slow of speech',
                'He had taken a vow of silence',
              ],
              'answer': 'He was not eloquent and was slow of speech',
              'explanation':
                  'Moses protested that he was not eloquent and was slow of speech and tongue, suggesting he was not a skilled orator. God responded that He would help Moses speak and teach him what to say.',
              'bibleReference': 'Exodus 4:10',
            },
            {
              'question': 'Who did God appoint to help Moses speak to Pharaoh?',
              'options': [
                'Miriam, his sister',
                'Aaron, his brother',
                'Jethro, his father-in-law',
                'Joshua, his servant',
              ],
              'answer': 'Aaron, his brother',
              'explanation':
                  'God appointed Aaron, Moses\' brother, to be his spokesman. Aaron would speak to the people while Moses would tell Aaron what God had said, and God would help them both.',
              'bibleReference': 'Exodus 4:14-16',
            },
            {
              'question':
                  'What did God instruct Moses to do before approaching the burning bush?',
              'options': [
                'Wash his hands in a nearby stream',
                'Bow his face to the ground',
                'Remove his sandals from his feet',
                'Cover his face with his cloak',
              ],
              'answer': 'Remove his sandals from his feet',
              'explanation':
                  'God told Moses: "Do not come any closer. Take off your sandals, for the place where you are standing is holy ground." This act signified reverence before God\'s holy presence.',
              'bibleReference': 'Exodus 3:5',
            },
            {
              'question': 'What miracle did God perform with Moses\' staff as a sign?',
              'options': [
                'It brought water out of a rock',
                'It divided a river',
                'It became a snake when thrown on the ground',
                'It blossomed with flowers overnight',
              ],
              'answer': 'It became a snake when thrown on the ground',
              'explanation':
                  'God told Moses to throw his staff on the ground, and it became a snake. Moses ran from it, but God told him to grab it by the tail and it became a staff again. This was a sign to authenticate Moses before Pharaoh and the Israelites.',
              'bibleReference': 'Exodus 4:3-4',
            },
            {
              'question':
                  'Which tribe did Moses belong to, according to the book of Exodus?',
              'options': ['Tribe of Judah', 'Tribe of Levi', 'Tribe of Reuben', 'Tribe of Joseph'],
              'answer': 'Tribe of Levi',
              'explanation':
                  'Moses was a descendant of Levi. His parents were Amram and Jochebed, both from the tribe of Levi. His brother Aaron and sister Miriam were also Levites.',
              'bibleReference': 'Exodus 2:1-2, Exodus 6:20',
            },
          ],
        },
        {
          'id': 'ten_plagues',
          'title': 'The Ten Plagues',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text': 'After forty years in Midian, God spoke to Moses from a burning bush and commissioned him to return to Egypt and demand that Pharaoh release the Israelites. Moses, with his brother Aaron, stood before Pharaoh. But God had said Pharaoh\'s heart would be hardened, and through this, God would demonstrate His supreme power over Egypt and all its gods.',
              'speaker': 'Narrator',
            },
            {
              'text': 'Pharaoh repeatedly refused to let Israel go. Each refusal was met with a devastating plague — turning the Nile to blood, filling the land with frogs, then gnats, then swarms of flies, then disease upon livestock. Each plague targeted one of Egypt\'s gods, showing that the God of Israel was Lord over all creation.',
              'speaker': 'Narrator',
            },
            {
              'text': 'The plagues intensified with painful boils on all the Egyptians, then a storm of hail mixed with fire that destroyed crops and livestock remaining in the fields, then locusts that devoured everything the hail had left, then a darkness so thick it could be felt — three days of absolute blackness over the land of Egypt.',
              'speaker': 'Narrator',
            },
            {
              'text': 'The final and most devastating plague was the death of the firstborn — from Pharaoh\'s own son to the firstborn of the prisoner in the dungeon. God instructed the Israelites to slaughter a lamb and paint its blood on their doorposts. The destroyer would pass over any house marked with blood. This night became the Passover — a feast Israel would celebrate forever.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'What was the first plague God sent upon Egypt?',
              'options': ['Frogs covering the land', 'Water turning to blood', 'Darkness for three days', 'A plague of locusts'],
              'answer': 'Water turning to blood',
              'explanation': 'In the first plague, Aaron struck the Nile with his staff and all the water in Egypt turned to blood, killing the fish and making the water undrinkable.',
              'bibleReference': 'Exodus 7:20-21',
            },
            {
              'question': 'What was the second plague sent upon Egypt?',
              'options': ['Gnats', 'Flies', 'Frogs', 'Locusts'],
              'answer': 'Frogs',
              'explanation': 'The second plague brought frogs up from the Nile in massive numbers to cover all of Egypt — the land, the houses, the beds, and even the ovens.',
              'bibleReference': 'Exodus 8:2-6',
            },
            {
              'question': 'Which plague involved tiny insects that came upon the people and animals of Egypt?',
              'options': ['Second plague', 'Third plague — gnats or lice', 'Fourth plague', 'Sixth plague'],
              'answer': 'Third plague — gnats or lice',
              'explanation': 'In the third plague, Aaron struck the dust of the earth and it became gnats (or lice) on people and animals throughout Egypt.',
              'bibleReference': 'Exodus 8:16-17',
            },
            {
              'question': 'Which plague brought death to the livestock and animals of Egypt?',
              'options': ['Third plague', 'Fourth plague', 'Fifth plague — pestilence on livestock', 'Seventh plague'],
              'answer': 'Fifth plague — pestilence on livestock',
              'explanation': 'The fifth plague was a severe pestilence on Egypt\'s livestock — horses, donkeys, camels, cattle, sheep and goats all died, but Israel\'s animals were untouched.',
              'bibleReference': 'Exodus 9:3-6',
            },
            {
              'question': 'Which plague caused painful sores and boils on people and animals?',
              'options': ['Fourth plague', 'Fifth plague', 'Sixth plague', 'Seventh plague'],
              'answer': 'Sixth plague',
              'explanation': 'The sixth plague brought festering boils that broke out on people and animals throughout Egypt, even affecting the magicians so they could not stand before Moses.',
              'bibleReference': 'Exodus 9:9-10',
            },
            {
              'question': 'What fell from the sky in the seventh plague?',
              'options': ['Burning ash and smoke', 'Hail mixed with fire', 'Acid rain and lightning', 'Flaming stones'],
              'answer': 'Hail mixed with fire',
              'explanation': 'The seventh plague was the worst hailstorm in Egypt\'s history — hail with lightning flashing through it struck down people, animals, and crops across Egypt.',
              'bibleReference': 'Exodus 9:23-24',
            },
            {
              'question': 'What covered all the land of Egypt in the eighth plague?',
              'options': ['Darkness', 'Frogs', 'Gnats', 'Locusts'],
              'answer': 'Locusts',
              'explanation': 'The eighth plague brought locusts that covered the whole land and devoured every plant and all the fruit of the trees left by the hail.',
              'bibleReference': 'Exodus 10:14-15',
            },
            {
              'question': 'How long did the thick darkness of the ninth plague last over Egypt?',
              'options': ['One day', 'Two days', 'Three days', 'Seven days'],
              'answer': 'Three days',
              'explanation': 'The ninth plague was total darkness over Egypt for three days — a darkness so dense it could be felt, though the Israelites had light in their homes.',
              'bibleReference': 'Exodus 10:22-23',
            },
            {
              'question': 'What protected the Israelites from the tenth and final plague — the death of the firstborn?',
              'options': ['Staying indoors all night', 'Wearing white garments', 'The blood of a lamb painted on their doorposts', 'Burning incense in their homes'],
              'answer': 'The blood of a lamb painted on their doorposts',
              'explanation': 'God instructed each Israelite family to slaughter a lamb and paint its blood on the top and sides of their doorframes; the destroyer would pass over those homes.',
              'bibleReference': 'Exodus 12:7, 12:13',
            },
            {
              'question': 'What annual feast was established to commemorate the final plague and Israel\'s deliverance?',
              'options': ['The Feast of Tabernacles', 'The Feast of Firstfruits', 'The Feast of Weeks', 'The Passover'],
              'answer': 'The Passover',
              'explanation': 'God commanded Israel to celebrate Passover every year as a lasting ordinance, commemorating how He passed over their homes when He struck Egypt.',
              'bibleReference': 'Exodus 12:14',
            },
          ],
        },
        {
          'id': 'red_sea_crossing',
          'title': 'Crossing the Red Sea and the Song of Miriam',
          'difficulty': 'Medium',
          'timerEnabled': true,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text': 'After the death of Egypt\'s firstborn, Pharaoh finally drove Israel out. But as the Israelites camped by the sea, Pharaoh had a change of heart. He hardened his heart once more and sent his entire army — 600 chariots and all of Egypt\'s finest horsemen — to drag Israel back into slavery.',
              'speaker': 'Narrator',
            },
            {
              'text': 'The people of Israel looked up and saw the Egyptian army bearing down on them. The sea was before them, the army behind them. They cried out in terror against Moses. But Moses declared, "Do not be afraid. Stand firm and you will see the deliverance the Lord will bring you today." God moved the pillar of cloud between the Israelites and the Egyptians through the night.',
              'speaker': 'Narrator',
            },
            {
              'text': 'God told Moses to stretch out his hand over the sea. A strong east wind blew all night and drove the water back, dividing the sea into two walls of water. The Israelites walked through on dry ground with the water like a wall on their right and their left. When the Egyptians pursued them into the sea, God looked down from the pillar of fire and threw their army into confusion.',
              'speaker': 'Narrator',
            },
            {
              'text': 'At dawn, Moses stretched his hand out again, and the waters rushed back over the Egyptians — every chariot, every horseman, every soldier. Not one survived. Israel saw the mighty power God had displayed, and the people feared the Lord and trusted in Him. Moses led all Israel in a great song of praise, and Miriam took up a tambourine and led all the women in dancing.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Why did Pharaoh change his mind and chase after the Israelites?',
              'options': ['He was angry they had taken Egyptian gold', 'He regretted letting them go and wanted them back as slaves', 'He wanted to make a new peace treaty', 'He was deceived by his magicians'],
              'answer': 'He regretted letting them go and wanted them back as slaves',
              'explanation': 'When Pharaoh was told that Israel had left, he and his officials changed their minds saying, "What have we done? We have let the Israelites go and have lost their services!"',
              'bibleReference': 'Exodus 14:5',
            },
            {
              'question': 'What stood between the Egyptians and Israelites at night by the sea?',
              'options': ['A great mountain', 'A river that appeared suddenly', 'A pillar of cloud and fire', 'An army of angels visible to both sides'],
              'answer': 'A pillar of cloud and fire',
              'explanation': 'The angel of God and the pillar of cloud moved from in front of Israel to behind them, coming between the two camps — giving light to Israel but bringing darkness to Egypt.',
              'bibleReference': 'Exodus 14:19-20',
            },
            {
              'question': 'What did God tell Moses to do to part the Red Sea?',
              'options': ['Strike the water with his staff', 'Stretch out his hand over the sea', 'Blow the trumpet three times', 'Pour salt into the water'],
              'answer': 'Stretch out his hand over the sea',
              'explanation': 'God told Moses to raise his staff and stretch out his hand over the sea to divide the water so the Israelites could walk through it on dry ground.',
              'bibleReference': 'Exodus 14:16',
            },
            {
              'question': 'What force drove back the waters of the Red Sea?',
              'options': ['A supernatural command with no physical cause', 'A strong east wind that blew all night', 'An earthquake that split the seabed', 'The angel of the Lord pushing the water aside'],
              'answer': 'A strong east wind that blew all night',
              'explanation': 'God drove the sea back with a strong east wind that blew all night, turning the sea into dry land.',
              'bibleReference': 'Exodus 14:21',
            },
            {
              'question': 'What did the Israelites walk on when they crossed through the parted Red Sea?',
              'options': ['Shallow water barely ankle deep', 'A path of large flat stones', 'Dry ground', 'Sand carried there by the wind'],
              'answer': 'Dry ground',
              'explanation': 'The Israelites went through the sea on dry ground, with the water forming a wall on their right and on their left.',
              'bibleReference': 'Exodus 14:22',
            },
            {
              'question': 'When did the waters of the Red Sea return and cover the Egyptian army?',
              'options': ['Immediately when the last Israelite crossed', 'At midnight', 'At dawn — the morning watch', 'When Moses spoke a prayer'],
              'answer': 'At dawn — the morning watch',
              'explanation': 'During the morning watch, God looked down on the Egyptian army and threw them into confusion; Moses stretched out his hand at dawn and the sea returned.',
              'bibleReference': 'Exodus 14:24-27',
            },
            {
              'question': 'What happened to the Egyptian army in the Red Sea?',
              'options': ['They turned back and escaped', 'They were taken prisoner', 'They were all drowned', 'They were blinded and wandered in the desert'],
              'answer': 'They were all drowned',
              'explanation': 'The water rushed back and covered the chariots and horsemen — the entire army of Pharaoh that had followed Israel into the sea. Not one of them survived.',
              'bibleReference': 'Exodus 14:28',
            },
            {
              'question': 'What instrument did Miriam play as she led the women in worship after crossing the sea?',
              'options': ['A harp', 'A lyre', 'A trumpet', 'A tambourine — timbrel'],
              'answer': 'A tambourine — timbrel',
              'explanation': 'Miriam the prophetess, Aaron\'s sister, took a tambourine in her hand, and all the women followed her with tambourines and dancing.',
              'bibleReference': 'Exodus 15:20',
            },
            {
              'question': 'Who led the women of Israel in song and dancing at the Red Sea?',
              'options': ['Zipporah, Moses\' wife', 'Jochebed, Moses\' mother', 'Miriam, Moses\' sister', 'The wife of Aaron'],
              'answer': 'Miriam, Moses\' sister',
              'explanation': 'Miriam the prophetess, sister of Moses and Aaron, led all the women with tambourines and dancing after the great deliverance at the sea.',
              'bibleReference': 'Exodus 15:20-21',
            },
            {
              'question': 'What was the central theme of Moses\' song after crossing the Red Sea?',
              'options': ['A call to rebuild the nation', 'Praise to God — the Lord is my strength and song', 'A warning to surrounding nations', 'A promise to return to Egypt'],
              'answer': 'Praise to God — the Lord is my strength and song',
              'explanation': 'Moses\' song begins "The Lord is my strength and my defense; He has become my salvation" — a triumphant praise to God for His mighty victory over Egypt.',
              'bibleReference': 'Exodus 15:2',
            },
          ],
        },
        {
          'id': 'wilderness_wandering',
          'title': 'Wandering in the Wilderness',
          'difficulty': 'Hard',
          'timerEnabled': true,
          'timerDurationSeconds': 25,
          'requiredCorrect': 7,
          'narratives': [
            {
              'text': 'Three days after their great victory at the sea, the Israelites found no water. At Marah they found water, but it was too bitter to drink. The people grumbled. God showed Moses a piece of wood; when he threw it into the water, it became sweet. God was testing whether Israel would trust Him and follow His ways.',
              'speaker': 'Narrator',
            },
            {
              'text': 'In the Desert of Sin, the people grumbled again, longing for Egypt\'s food. God responded with miraculous provision — quail covered the camp at evening, and in the morning a thin white flaky substance covered the ground like frost. The people asked, "What is it?" — and Moses told them it was the bread God had given them. They called it manna.',
              'speaker': 'Narrator',
            },
            {
              'text': 'At Mount Sinai, God spoke directly to Moses and gave Israel the Ten Commandments — the foundation of His covenant with His people. But while Moses was on the mountain for forty days, the people below grew impatient. They pressured Aaron into making a golden calf and worshipped it, a catastrophic act of idolatry that brought serious judgment.',
              'speaker': 'Narrator',
            },
            {
              'text': 'From Sinai, Israel journeyed to the border of Canaan. Moses sent twelve spies to explore the land. Ten came back with a fearful report — the people are giants, we are like grasshoppers! Only Joshua and Caleb urged Israel to trust God and enter. The people\'s unbelief led to forty years of wandering in the wilderness — one year for each day the spies had explored the land.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'What did God use to make the bitter water at Marah sweet?',
              'options': ['Moses\' staff', 'Holy ash from the altar', 'A piece of wood — a tree', 'Salt from the desert'],
              'answer': 'A piece of wood — a tree',
              'explanation': 'God showed Moses a piece of wood; when Moses threw it into the bitter water, the water became sweet and drinkable.',
              'bibleReference': 'Exodus 15:25',
            },
            {
              'question': 'What did manna look like when the Israelites first saw it?',
              'options': ['Yellow like corn', 'Brown like dried fruit', 'White like coriander seed', 'Clear like ice crystals'],
              'answer': 'White like coriander seed',
              'explanation': 'Manna was white like coriander seed and tasted like wafers made with honey, appearing on the ground like frost each morning.',
              'bibleReference': 'Exodus 16:31',
            },
            {
              'question': 'What meat did God provide for the Israelites in the wilderness besides manna?',
              'options': ['Doves', 'Partridge', 'Quail', 'Wild goats'],
              'answer': 'Quail',
              'explanation': 'In the evening quail came and covered the camp, and in the morning manna appeared — God provided both bread and meat for Israel in the desert.',
              'bibleReference': 'Exodus 16:13',
            },
            {
              'question': 'Who made the golden calf while Moses was on Mount Sinai?',
              'options': ['Korah the Levite', 'Bezalel the craftsman', 'Aaron, Moses\' brother', 'The elders of Israel'],
              'answer': 'Aaron, Moses\' brother',
              'explanation': 'Aaron gave in to the people\'s pressure, collected their gold earrings, fashioned them into a golden calf, and declared a festival to the Lord — a terrible act of idolatry.',
              'bibleReference': 'Exodus 32:2-5',
            },
            {
              'question': 'What did Moses do to the golden calf when he came down from the mountain?',
              'options': ['Buried it in the desert', 'Threw it in the sea', 'Ground it to powder, mixed it with water, and made the people drink it', 'Melted it and used the gold for the tabernacle'],
              'answer': 'Ground it to powder, mixed it with water, and made the people drink it',
              'explanation': 'Moses burned the golden calf in fire, ground it to powder, scattered it on the water, and made the Israelites drink it — showing the utter worthlessness of their idol.',
              'bibleReference': 'Exodus 32:20',
            },
            {
              'question': 'How many commandments were written on the stone tablets at Mount Sinai?',
              'options': ['Five', 'Seven', 'Ten', 'Twelve'],
              'answer': 'Ten',
              'explanation': 'God wrote the Ten Commandments on two stone tablets, forming the foundation of His covenant with Israel.',
              'bibleReference': 'Exodus 34:28',
            },
            {
              'question': 'How many spies did Moses send to explore the land of Canaan?',
              'options': ['7', '10', '12', '14'],
              'answer': '12',
              'explanation': 'Moses sent twelve spies — one leader from each of the twelve tribes of Israel — to explore the land of Canaan for forty days.',
              'bibleReference': 'Numbers 13:2',
            },
            {
              'question': 'Which two spies brought back a faithful, encouraging report about entering the Promised Land?',
              'options': ['Moses and Aaron', 'Caleb and Joshua', 'Shammua and Shaphat', 'Igal and Palti'],
              'answer': 'Caleb and Joshua',
              'explanation': 'Caleb and Joshua urged the people to go up and take the land immediately, trusting God — unlike the other ten spies who spread a fearful report.',
              'bibleReference': 'Numbers 13:30, Numbers 14:6-9',
            },
            {
              'question': 'Why did God sentence Israel to wander in the wilderness for 40 years?',
              'options': ['Because they worshipped the golden calf', 'Because they grumbled about the manna', 'Because they refused to enter the Promised Land out of fear and unbelief', 'Because Moses disobeyed God at Sinai'],
              'answer': 'Because they refused to enter the Promised Land out of fear and unbelief',
              'explanation': 'Israel wept and refused to enter Canaan, fearing the powerful inhabitants. God declared they would wander one year for each day the spies explored — 40 years total.',
              'bibleReference': 'Numbers 14:33-34',
            },
            {
              'question': 'Where did Moses receive the Ten Commandments from God?',
              'options': ['Mount Zion', 'Mount Nebo', 'Mount Carmel', 'Mount Sinai'],
              'answer': 'Mount Sinai',
              'explanation': 'God called Moses up to Mount Sinai where He wrote the Ten Commandments on two stone tablets and gave Israel the Law of the covenant.',
              'bibleReference': 'Exodus 19:20, Exodus 31:18',
            },
          ],
        },
      ],
    },

    // =========================================================
    // ARC 2: THE LIFE OF DAVID
    // =========================================================
    {
      'id': 'life_of_david',
      'title': 'The Life of David',
      'description':
          'From humble shepherd boy to the greatest king of Israel — journey through David\'s life of faith, failure, war, and worship.',
      'chapters': [
        // Chapter 1: From Shepherd to Anointed King
        {
          'id': 'shepherd_to_king',
          'title': 'From Shepherd to Anointed King',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'God had rejected Saul as king of Israel because of his disobedience. He sent the prophet Samuel on a secret mission to the small town of Bethlehem, to the household of a man named Jesse. God had chosen one of Jesse\'s sons to be the next king — but He did not choose the way men choose. Where humans look at outward appearance, God looks at the heart.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Jesse brought seven of his sons before Samuel one by one. Each time Samuel saw a tall, impressive young man, he thought surely this was God\'s anointed — but God said no to each one. Finally Samuel asked Jesse: "Are these all the sons you have?" Jesse answered that the youngest was out in the fields tending the sheep. David was summoned, and the moment he arrived, God said to Samuel: "Rise and anoint him; this is the one."',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Samuel took the horn of oil and anointed David in the presence of his brothers, and from that day on the Spirit of the Lord came powerfully upon David. Though anointed king, David did not immediately take the throne. He continued his humble work as a shepherd and became known at the royal court as a skilled musician — his playing on the harp brought relief to King Saul when an evil spirit tormented him.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Who was sent by God to anoint David as the next king of Israel?',
              'options': ['Nathan the prophet', 'Elijah', 'Samuel', 'Gad the seer'],
              'answer': 'Samuel',
              'explanation':
                  'God instructed the prophet Samuel to travel to Bethlehem to the house of Jesse, where God had chosen the next king. Samuel anointed David with oil in the presence of his brothers.',
              'bibleReference': '1 Samuel 16:1, 12-13',
            },
            {
              'question': 'In which town did Jesse and David\'s family live?',
              'options': ['Hebron', 'Jerusalem', 'Bethlehem', 'Gibeah'],
              'answer': 'Bethlehem',
              'explanation':
                  'Jesse and his family lived in Bethlehem in Judah. Samuel went there to anoint the next king. Bethlehem later became known as the City of David, and is also the birthplace of Jesus Christ.',
              'bibleReference': '1 Samuel 16:1, 4',
            },
            {
              'question': 'What was David doing when Samuel came to Jesse\'s house?',
              'options': [
                'Training as a soldier',
                'Studying the Scriptures with the elders',
                'Tending the sheep in the fields',
                'Preparing a feast for Samuel\'s arrival',
              ],
              'answer': 'Tending the sheep in the fields',
              'explanation':
                  'When Samuel asked Jesse if these were all his sons, Jesse replied that the youngest was out tending the sheep. David was summoned from the fields and anointed as king that same day.',
              'bibleReference': '1 Samuel 16:11',
            },
            {
              'question':
                  'How many of Jesse\'s sons were presented to Samuel before David was called?',
              'options': ['5', '6', '7', '8'],
              'answer': '7',
              'explanation':
                  'Jesse presented seven of his sons to Samuel, but God rejected all of them. Only then did Samuel ask if there were any more sons, and David — the eighth son — was called from the fields.',
              'bibleReference': '1 Samuel 16:10-11',
            },
            {
              'question':
                  'What does God tell Samuel when he saw Jesse\'s eldest son Eliab and thought he must be God\'s chosen?',
              'options': [
                '"He is worthy but not chosen."',
                '"Do not consider his appearance or height, for the Lord looks at the heart."',
                '"He will make a great warrior but not a king."',
                '"He is too proud to lead my people."',
              ],
              'answer': '"Do not consider his appearance or height, for the Lord looks at the heart."',
              'explanation':
                  'God told Samuel not to consider outward appearance or height, because the Lord does not look at the things people look at. People look at the outward appearance, but the Lord looks at the heart.',
              'bibleReference': '1 Samuel 16:7',
            },
            {
              'question': 'What was the name of David\'s father?',
              'options': ['Boaz', 'Jesse', 'Obed', 'Salmon'],
              'answer': 'Jesse',
              'explanation':
                  'David was the son of Jesse, an Ephrathite from Bethlehem in Judah. Jesse had eight sons, and David was the youngest. Jesse was the grandson of Boaz and Ruth.',
              'bibleReference': '1 Samuel 16:1, Ruth 4:17',
            },
            {
              'question':
                  'Among his brothers, what was David\'s birth order?',
              'options': [
                'The firstborn',
                'The middle son',
                'The second youngest',
                'The youngest',
              ],
              'answer': 'The youngest',
              'explanation':
                  'David was the youngest of Jesse\'s eight sons. His older brothers looked down on him, and even his own father did not initially think to call him when Samuel came — David was considered the least likely candidate.',
              'bibleReference': '1 Samuel 16:11, 17:14',
            },
            {
              'question':
                  'What musical instrument did David play that soothed King Saul?',
              'options': ['Trumpet', 'Lyre (harp)', 'Flute', 'Cymbals'],
              'answer': 'Lyre (harp)',
              'explanation':
                  'David was known as a skilled musician and played the lyre (harp) beautifully. Saul\'s servants recommended David to the king, and whenever an evil spirit tormented Saul, David would play and relief would come.',
              'bibleReference': '1 Samuel 16:16, 23',
            },
            {
              'question': 'From which tribe of Israel was David descended?',
              'options': ['Tribe of Benjamin', 'Tribe of Levi', 'Tribe of Judah', 'Tribe of Ephraim'],
              'answer': 'Tribe of Judah',
              'explanation':
                  'David was from the tribe of Judah, born in Bethlehem of Judah. This fulfilled the ancient prophecy in Genesis 49:10 that the scepter would not depart from Judah. Jesus Christ was also born from the tribe of Judah and the line of David.',
              'bibleReference': '1 Samuel 17:12, Genesis 49:10',
            },
            {
              'question':
                  'What happened to David from the moment he was anointed by Samuel?',
              'options': [
                'He was immediately crowned king in Jerusalem',
                'The Spirit of the Lord came powerfully upon him',
                'An angel appeared to him in a vision',
                'He was given the sword of Goliath as a sign',
              ],
              'answer': 'The Spirit of the Lord came powerfully upon him',
              'explanation':
                  'From the day Samuel anointed David, the Spirit of the Lord came powerfully upon David. This divine empowerment equipped David for the great tasks God had prepared for him, including facing Goliath.',
              'bibleReference': '1 Samuel 16:13',
            },
          ],
        },

        // Chapter 2: David and Goliath
        {
          'id': 'david_goliath',
          'title': 'David and Goliath',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'The Philistines gathered their army for war against Israel in the Valley of Elah. Among them was a terrifying champion named Goliath of Gath — a giant of a man, standing over nine feet tall, dressed head to toe in bronze armor. For forty days, morning and evening, Goliath strode out and bellowed his challenge: send someone to fight me one on one, and the losing side will serve the other.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'The Israelite army trembled with fear, and no one dared to accept the challenge. David arrived at the camp to bring supplies to his brothers and heard Goliath\'s taunting. While all the soldiers shrank back in terror, David was outraged that this uncircumcised Philistine was defying the armies of the living God. He volunteered to fight, despite being mocked by his own brothers and doubted by King Saul.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'King Saul offered David his armor and sword, but David tried them on and said he was not used to them. He set them aside and chose his own familiar weapons — a sling and five smooth stones picked from a stream. As David approached, Goliath sneered and cursed him by his gods. David answered: "You come against me with sword and spear and javelin, but I come against you in the name of the Lord Almighty."',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question':
                  'For how many days did Goliath come out and challenge the Israelites before David arrived?',
              'options': ['7 days', '20 days', '40 days', '30 days'],
              'answer': '40 days',
              'explanation':
                  'Goliath came forward every morning and evening for forty days, challenging the Israelites to send a champion to fight him in single combat. The number forty is significant throughout Scripture as a period of testing.',
              'bibleReference': '1 Samuel 17:16',
            },
            {
              'question': 'What weapons did David use to fight Goliath?',
              'options': [
                'A sword and shield',
                'Saul\'s armor and spear',
                'A sling and a stone',
                'A bow and arrow',
              ],
              'answer': 'A sling and a stone',
              'explanation':
                  'David took his shepherd\'s staff, chose five smooth stones from a stream, and used his sling to fight Goliath. He reached into his bag, took out a stone, and slung it, striking Goliath on the forehead.',
              'bibleReference': '1 Samuel 17:40, 49',
            },
            {
              'question': 'What was Goliath\'s nationality?',
              'options': ['Amalekite', 'Moabite', 'Philistine', 'Canaanite'],
              'answer': 'Philistine',
              'explanation':
                  'Goliath was from Gath, one of the five principal cities of the Philistines. The Philistines were the primary military enemies of Israel during the period of the judges and the early monarchy.',
              'bibleReference': '1 Samuel 17:4',
            },
            {
              'question':
                  'How many smooth stones did David pick up before facing Goliath?',
              'options': ['1', '3', '5', '7'],
              'answer': '5',
              'explanation':
                  'David chose five smooth stones from a stream and put them in the pouch of his shepherd\'s bag. He only needed one — but taking five may reflect his readiness to also face Goliath\'s four brothers, who are mentioned later in Scripture.',
              'bibleReference': '1 Samuel 17:40',
            },
            {
              'question': 'After Goliath fell, what did David use to kill him and cut off his head?',
              'options': [
                'His shepherd\'s staff',
                'A second stone from his sling',
                'Goliath\'s own sword',
                'A sword given by Saul',
              ],
              'answer': 'Goliath\'s own sword',
              'explanation':
                  'David ran to where Goliath had fallen, drew the giant\'s own sword from its sheath, and cut off his head. David had no sword of his own, so he used Goliath\'s weapon to finish the battle.',
              'bibleReference': '1 Samuel 17:51',
            },
            {
              'question': 'Approximately how tall was Goliath according to Scripture?',
              'options': ['6 feet tall', '7 feet tall', 'About 9 feet tall', 'Over 12 feet tall'],
              'answer': 'About 9 feet tall',
              'explanation':
                  'Goliath\'s height is recorded as "six cubits and a span." Using standard cubit measurements, this translates to approximately 9 feet 9 inches (nearly 3 meters) — an extraordinary and terrifying height.',
              'bibleReference': '1 Samuel 17:4',
            },
            {
              'question': 'In which valley did the battle between David and Goliath take place?',
              'options': [
                'The Valley of Jezreel',
                'The Valley of Elah',
                'The Valley of Aijalon',
                'The Kidron Valley',
              ],
              'answer': 'The Valley of Elah',
              'explanation':
                  'The Philistines and Israelites faced each other across the Valley of Elah, with the Philistines on one hill and Israel on another. It was in this valley that David defeated Goliath.',
              'bibleReference': '1 Samuel 17:2-3',
            },
            {
              'question':
                  'What did David declare as he approached Goliath on the battlefield?',
              'options': [
                '"The God of Israel will deliver you into my hand today."',
                '"I come against you in the name of the Lord Almighty."',
                '"This day I will avenge the honor of all Israel."',
                '"The battle belongs to the one who has the stronger arm."',
              ],
              'answer': '"I come against you in the name of the Lord Almighty."',
              'explanation':
                  'David said to Goliath: "You come against me with sword and spear and javelin, but I come against you in the name of the Lord Almighty, the God of the armies of Israel, whom you have defied." This declaration of faith is one of Scripture\'s most memorable.',
              'bibleReference': '1 Samuel 17:45',
            },
            {
              'question':
                  'What did King Saul offer David before sending him to fight Goliath?',
              'options': [
                'A chariot and two horses',
                'His own armor and weapons',
                'Three thousand soldiers as backup',
                'A generous reward and his daughter\'s hand',
              ],
              'answer': 'His own armor and weapons',
              'explanation':
                  'Saul dressed David in his own tunic, coat of armor, and bronze helmet, and fastened a sword to him. But David said he could not go in them because he was not used to them, and he took them off.',
              'bibleReference': '1 Samuel 17:38-39',
            },
            {
              'question':
                  'How did David\'s brothers react when they heard him asking about Goliath and the reward?',
              'options': [
                'They encouraged him to be brave',
                'They begged him to fight on their behalf',
                'They became angry and accused him of being conceited',
                'They warned him about Goliath\'s great strength',
              ],
              'answer': 'They became angry and accused him of being conceited',
              'explanation':
                  'David\'s eldest brother Eliab heard him talking to the soldiers and burned with anger at David. He accused David of being conceited and wicked, saying he had only come to watch the battle.',
              'bibleReference': '1 Samuel 17:28',
            },
          ],
        },

        // Chapter 3: David and Jonathan
        {
          'id': 'david_and_jonathan',
          'title': 'David and Jonathan',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'After David\'s victory over Goliath, a deep and remarkable friendship formed between David and Saul\'s son Jonathan. Jonathan loved David as himself, and the two made a covenant of friendship. Jonathan gave David his robe, tunic, sword, bow, and belt — a symbolic act that many scholars see as Jonathan recognizing David\'s right to the throne that Jonathan himself stood to inherit.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'As David\'s fame grew, Saul became consumed with jealousy and sought to kill him. Jonathan repeatedly risked his own life to protect David, warning him of his father\'s murderous intentions. The two devised a signal system using arrows to secretly communicate whether it was safe for David to return. When Jonathan shot the arrows and sent the boy away, David came out of hiding to say goodbye, and the two wept together, knowing they might never meet again.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Jonathan and his father Saul were both killed in battle against the Philistines at Mount Gilboa. When the news reached David, he mourned deeply and composed the Song of the Bow — a beautiful lament for both Saul and Jonathan. Of Jonathan, David sang: "Your love for me was wonderful, more wonderful than that of women." This friendship between David and Jonathan became one of the greatest examples of loyal, selfless love in all of Scripture.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Years later, when David was established as king, he remembered his covenant with Jonathan and asked: "Is there anyone still left of the house of Saul to whom I can show kindness for Jonathan\'s sake?" He discovered that Jonathan had a son named Mephibosheth, who was crippled in both feet. David brought him to Jerusalem, restored all the land of Saul to him, and had him eat at the royal table always — as one of the king\'s own sons.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Who was Jonathan\'s father?',
              'options': ['David', 'Samuel', 'Saul', 'Abner'],
              'answer': 'Saul',
              'explanation':
                  'Jonathan was the son of King Saul, the first king of Israel. Despite his father\'s hatred of David, Jonathan remained David\'s closest and most loyal friend throughout his life.',
              'bibleReference': '1 Samuel 14:1',
            },
            {
              'question':
                  'What did Jonathan give David as a sign of their covenant friendship?',
              'options': [
                'His crown and royal signet ring',
                'His robe, tunic, sword, bow, and belt',
                'A scroll containing the law',
                'Fifty servants and three chariots',
              ],
              'answer': 'His robe, tunic, sword, bow, and belt',
              'explanation':
                  'Jonathan took off the robe he was wearing and gave it to David, along with his tunic, sword, bow, and belt. This symbolic gesture showed Jonathan\'s love and is often interpreted as recognizing David\'s future kingship.',
              'bibleReference': '1 Samuel 18:3-4',
            },
            {
              'question':
                  'How does the Bible describe the depth of Jonathan\'s love for David?',
              'options': [
                'Greater than a father\'s love',
                'More wonderful than the love of women',
                'Equal to the love of a son',
                'Like the love of God for His people',
              ],
              'answer': 'More wonderful than the love of women',
              'explanation':
                  'In his lament over Jonathan\'s death, David said: "I grieve for you, Jonathan my brother; you were very dear to me. Your love for me was wonderful, more wonderful than that of women." This describes the depth of their covenant friendship.',
              'bibleReference': '2 Samuel 1:26',
            },
            {
              'question':
                  'What was the name of Jonathan\'s crippled son whom David later showed kindness to?',
              'options': ['Ishbosheth', 'Mephibosheth', 'Merab', 'Abner'],
              'answer': 'Mephibosheth',
              'explanation':
                  'Mephibosheth was Jonathan\'s son, who had been dropped by his nurse when he was five years old and became crippled in both feet. King David honored his covenant with Jonathan by showing great kindness to Mephibosheth.',
              'bibleReference': '2 Samuel 4:4, 9:6',
            },
            {
              'question':
                  'How did Jonathan secretly warn David that his life was in danger from Saul?',
              'options': [
                'By sending a trusted servant with a letter',
                'By giving a prearranged signal with arrows',
                'By leaving a marked stone at their meeting place',
                'By appearing to him in a dream',
              ],
              'answer': 'By giving a prearranged signal with arrows',
              'explanation':
                  'Jonathan and David arranged a signal using arrows. Jonathan would shoot arrows and send a boy to retrieve them. If Jonathan shouted "the arrows are on this side of you," it meant safety. If he shouted "the arrows are beyond you," it meant danger and David must flee.',
              'bibleReference': '1 Samuel 20:20-22, 36-38',
            },
            {
              'question': 'Who was the rightful heir to Saul\'s throne before David?',
              'options': ['Abner', 'Ishbosheth', 'Jonathan', 'Mephibosheth'],
              'answer': 'Jonathan',
              'explanation':
                  'As Saul\'s eldest son, Jonathan was the natural heir to the throne of Israel. His friendship with David and his recognition of David\'s anointing meant he voluntarily surrendered his claim, making their friendship all the more remarkable.',
              'bibleReference': '1 Samuel 18:1-4, 23:17',
            },
            {
              'question': 'Where were Saul and Jonathan killed in battle?',
              'options': [
                'On the plains of Megiddo',
                'At the fortress of Jerusalem',
                'At Mount Gilboa',
                'In the Valley of Elah',
              ],
              'answer': 'At Mount Gilboa',
              'explanation':
                  'Saul and his sons, including Jonathan, fell in battle against the Philistines at Mount Gilboa. Saul was badly wounded by archers and fell on his own sword. Jonathan died fighting alongside him.',
              'bibleReference': '1 Samuel 31:1-4, 2 Samuel 1:6',
            },
            {
              'question': 'What did David compose when he heard about the deaths of Saul and Jonathan?',
              'options': [
                'Psalm 23',
                'The Song of the Bow',
                'Psalm 51',
                'A thanksgiving prayer',
              ],
              'answer': 'The Song of the Bow',
              'explanation':
                  'David composed a lament called the Song of the Bow and ordered it to be taught to the people of Judah. It is recorded in 2 Samuel 1 and mourns the deaths of both Saul and Jonathan.',
              'bibleReference': '2 Samuel 1:17-18',
            },
            {
              'question':
                  'What covenant did David and Jonathan make together?',
              'options': [
                'A military alliance against the Philistines',
                'A promise that Jonathan would be David\'s commander',
                'A covenant of loyal friendship and kindness to each other\'s families',
                'An agreement to share the throne equally',
              ],
              'answer': 'A covenant of loyal friendship and kindness to each other\'s families',
              'explanation':
                  'Jonathan and David made a covenant of friendship, and Jonathan made David swear an oath by his love for him. The covenant included showing kindness to each other\'s families forever, which David later honored with Mephibosheth.',
              'bibleReference': '1 Samuel 20:14-17, 42',
            },
            {
              'question':
                  'What did David do to honor his covenant with Jonathan after becoming king?',
              'options': [
                'He named his firstborn son Jonathan',
                'He built a memorial in Jonathan\'s honor',
                'He restored Saul\'s land to Mephibosheth and let him eat at the royal table',
                'He declared a national day of mourning each year',
              ],
              'answer': 'He restored Saul\'s land to Mephibosheth and let him eat at the royal table',
              'explanation':
                  'David restored all the land of Saul to Mephibosheth and commanded that he always eat at the king\'s table, treating him like one of his own sons. This fulfilled the covenant David had made with Jonathan.',
              'bibleReference': '2 Samuel 9:7-13',
            },
          ],
        },

        // Chapter 4: David Becomes King
        {
          'id': 'david_king',
          'title': 'David Becomes King',
          'difficulty': 'Medium',
          'timerEnabled': true,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'After the deaths of Saul and Jonathan, David inquired of the Lord and was told to go up to Hebron, where the men of Judah came and anointed him king over the house of Judah. For seven years and six months David ruled from Hebron while a civil war raged between his supporters and those loyal to Saul\'s surviving son Ishbosheth. Eventually all the tribes of Israel came to David in Hebron and anointed him king over all Israel.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'David captured the stronghold of Jerusalem from the Jebusites and made it his royal city — the City of David. He then brought the Ark of the Covenant to Jerusalem in a great celebration, dancing before the Lord with all his might. Jerusalem became not only the political capital of Israel but the spiritual center of the nation, the city where God had chosen to place His name.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'David desired to build a permanent temple for God, but the prophet Nathan brought a message from the Lord: David was a man of war and had shed much blood. Instead, God made an extraordinary covenant with David — his son would build the temple, and God would establish David\'s throne forever. This Davidic Covenant became one of the most important promises in all of Scripture, pointing ultimately to Jesus Christ, the eternal Son of David.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'David\'s reign was not without failure. His greatest sin came when he committed adultery with Bathsheba and arranged for her husband Uriah to be killed in battle. The prophet Nathan confronted David boldly, and David repented with deep sorrow — Psalm 51 captures his anguished prayer. Despite his failures, David remained a man after God\'s own heart, and he reigned over all Israel for forty years, leaving behind a legacy of Psalms, worship, and a kingdom prepared for his son Solomon.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question':
                  'Where was David first anointed king, before becoming king over all Israel?',
              'options': ['Jerusalem', 'Bethlehem', 'Hebron', 'Gibeah'],
              'answer': 'Hebron',
              'explanation':
                  'After Saul\'s death, David inquired of God and went up to Hebron, where the men of Judah anointed him king over the house of Judah. He reigned there for seven and a half years before becoming king over all Israel.',
              'bibleReference': '2 Samuel 2:1-4, 5:5',
            },
            {
              'question':
                  'What sacred object did David bring to Jerusalem in a great procession?',
              'options': [
                'The bronze altar from Gibeon',
                'The Ark of the Covenant',
                'The tabernacle of Moses',
                'The stone tablets of the law',
              ],
              'answer': 'The Ark of the Covenant',
              'explanation':
                  'David brought the Ark of the Covenant to Jerusalem with great celebration. He danced before the Lord with all his might, wearing a linen ephod. The Ark represented the presence of God among His people.',
              'bibleReference': '2 Samuel 6:12-15',
            },
            {
              'question':
                  'Why did God tell David he could not build the temple?',
              'options': [
                'He was not from the tribe of Levi',
                'He had not received the necessary training',
                'He was a man of war who had shed much blood',
                'He had failed to keep the Law of Moses',
              ],
              'answer': 'He was a man of war who had shed much blood',
              'explanation':
                  'God told David through the prophet Nathan — and later David himself explains — that David could not build the temple because he had shed much blood and fought many wars. Instead, God designated David\'s son Solomon, a man of peace, to build it.',
              'bibleReference': '1 Chronicles 22:8, 2 Samuel 7:5-13',
            },
            {
              'question': 'Who would build the temple according to God\'s promise to David?',
              'options': ['Nathan', 'Solomon', 'Joab', 'Absalom'],
              'answer': 'Solomon',
              'explanation':
                  'God promised David that his son Solomon would build the temple. God said: "He is the one who will build a house for my Name, and I will establish the throne of his kingdom forever." Solomon indeed built the magnificent first temple in Jerusalem.',
              'bibleReference': '2 Samuel 7:13, 1 Kings 6:1',
            },
            {
              'question': 'What are the collection of songs and poems David is famous for writing?',
              'options': ['The Proverbs', 'The Psalms', 'The Lamentations', 'The Song of Songs'],
              'answer': 'The Psalms',
              'explanation':
                  'David wrote approximately half of the 150 Psalms in the Bible, including some of the most beloved — Psalm 23 ("The Lord is my shepherd"), Psalm 51 (his prayer of repentance), and Psalm 22 (a messianic psalm). He is called the "sweet psalmist of Israel."',
              'bibleReference': '2 Samuel 23:1, Psalm titles',
            },
            {
              'question': 'How many total years did David reign as king of Israel?',
              'options': ['20 years', '33 years', '40 years', '47 years'],
              'answer': '40 years',
              'explanation':
                  'David reigned for a total of forty years — seven years and six months in Hebron over Judah, and thirty-three years in Jerusalem over all Israel and Judah.',
              'bibleReference': '2 Samuel 5:4-5, 1 Kings 2:11',
            },
            {
              'question':
                  'Which city did David capture from the Jebusites to make his royal capital?',
              'options': ['Bethlehem', 'Hebron', 'Shechem', 'Jerusalem'],
              'answer': 'Jerusalem',
              'explanation':
                  'David captured the fortress of Zion from the Jebusites — the stronghold later called the City of David. He made Jerusalem his capital and it became the most important city in Israel\'s history.',
              'bibleReference': '2 Samuel 5:6-9',
            },
            {
              'question': 'Who was David\'s first wife?',
              'options': ['Bathsheba', 'Abigail', 'Michal', 'Ahinoam'],
              'answer': 'Michal',
              'explanation':
                  'Michal, the daughter of King Saul, was David\'s first wife. Saul had given her to David after David killed two hundred Philistines as a bride price. She later despised David for dancing before the Ark of the Lord.',
              'bibleReference': '1 Samuel 18:27, 2 Samuel 6:16',
            },
            {
              'question':
                  'Which prophet confronted David about his sin with Bathsheba and the murder of Uriah?',
              'options': ['Samuel', 'Elijah', 'Nathan', 'Gad'],
              'answer': 'Nathan',
              'explanation':
                  'The prophet Nathan came to David and told him a parable about a rich man who stole a poor man\'s lamb, then revealed: "You are the man!" David confessed his sin, and Psalm 51 captures his prayer of repentance.',
              'bibleReference': '2 Samuel 12:1-13',
            },
            {
              'question':
                  'What did God promise about David\'s throne as part of the Davidic Covenant?',
              'options': [
                'It would last one thousand years',
                'It would be established forever',
                'It would pass only to sons who obeyed the law',
                'It would be the most powerful throne on earth',
              ],
              'answer': 'It would be established forever',
              'explanation':
                  'God promised David through Nathan: "Your house and your kingdom will endure forever before me; your throne will be established forever." This Davidic Covenant is fulfilled ultimately in Jesus Christ, who is called the Son of David and reigns eternally.',
              'bibleReference': '2 Samuel 7:16',
            },
          ],
        },
      ],
    },

    // Arcs 3-6 appended below
    {
      'id': 'pauls_journeys',
      'title': 'Paul\'s Missionary Journeys',
      'description':
          'From persecutor of Christians to the greatest missionary the world has known — follow Saul of Tarsus as he becomes Paul and takes the gospel across the Roman Empire.',
      'chapters': [
        // Chapter 1: The Road to Damascus
        {
          'id': 'road_to_damascus',
          'title': 'The Road to Damascus',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'Saul of Tarsus was a feared name among early followers of Jesus. Armed with letters of authority from the high priest, he hunted down believers in Jerusalem and beyond, dragging them from their homes and throwing them into prison. His zeal for Jewish law was unmatched, and he saw the followers of \'The Way\' as dangerous heretics who had to be silenced.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'As Saul traveled the dusty road to Damascus, intent on arresting more Christians, a light from heaven suddenly blazed around him — brighter than the midday sun. He fell to the ground, and a voice thundered: "Saul, Saul, why do you persecute me?" Trembling, Saul asked, "Who are you, Lord?" The answer changed everything: "I am Jesus, whom you are persecuting."',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Saul rose from the ground to find he could not see. His companions led him by the hand into Damascus, where he spent three days without sight, neither eating nor drinking. In the city lived a disciple named Ananias, whom God called in a vision and instructed to find Saul. Though afraid of Saul\'s reputation, Ananias obeyed, placed his hands on Saul, and said, "Brother Saul, receive your sight." Immediately, something like scales fell from Saul\'s eyes.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Filled with the Holy Spirit and restored in sight, Saul was baptized at once. The man who had come to Damascus to arrest Christians now began preaching in the synagogues that Jesus is the Son of God. The transformation was so dramatic that those who heard him were astonished — this was the same man who had caused such havoc in Jerusalem! From that day forward, Saul — also known as Paul — would become the most tireless missionary the church has ever known.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'What was Saul\'s original purpose in traveling to Damascus?',
              'options': [
                'To preach in the synagogues',
                'To arrest followers of Jesus',
                'To meet the high priest',
                'To study under a new teacher',
              ],
              'answer': 'To arrest followers of Jesus',
              'explanation':
                  'Saul traveled to Damascus with letters from the high priest authorizing him to arrest any followers of the Way and bring them back to Jerusalem.',
              'bibleReference': 'Acts 9:1-2',
            },
            {
              'question': 'What appeared to Saul on the road to Damascus?',
              'options': [
                'An angel with a sword',
                'A pillar of fire',
                'A blinding light from heaven',
                'A vision of the temple',
              ],
              'answer': 'A blinding light from heaven',
              'explanation':
                  'A light from heaven, brighter than the sun, suddenly flashed around Saul, causing him to fall to the ground.',
              'bibleReference': 'Acts 9:3',
            },
            {
              'question': 'How long was Saul blind after his encounter with Jesus?',
              'options': [
                '1 day',
                '3 days',
                '7 days',
                '40 days',
              ],
              'answer': '3 days',
              'explanation':
                  'Saul was blind for three days, during which time he neither ate nor drank, waiting in Damascus.',
              'bibleReference': 'Acts 9:9',
            },
            {
              'question': 'Who did God send to restore Saul\'s sight?',
              'options': [
                'Barnabas',
                'Stephen',
                'Peter',
                'Ananias',
              ],
              'answer': 'Ananias',
              'explanation':
                  'God appeared to a disciple in Damascus named Ananias in a vision, directing him to go to Saul and lay hands on him so his sight would be restored.',
              'bibleReference': 'Acts 9:10-12',
            },
            {
              'question': 'What is the other name by which Saul is widely known?',
              'options': [
                'Barnabas',
                'Silas',
                'Paul',
                'Timothy',
              ],
              'answer': 'Paul',
              'explanation':
                  'Saul of Tarsus was also known by his Roman name Paul, which is predominantly used throughout the book of Acts and his letters.',
              'bibleReference': 'Acts 13:9',
            },
            {
              'question': 'Saul gave approval to the killing of which early Christian martyr?',
              'options': [
                'James',
                'Philip',
                'Stephen',
                'Barnabas',
              ],
              'answer': 'Stephen',
              'explanation':
                  'When Stephen was stoned to death, Saul stood nearby giving his approval and watched over the cloaks of those who stoned him.',
              'bibleReference': 'Acts 7:58-8:1',
            },
            {
              'question': 'What did Saul do immediately after his sight was restored by Ananias?',
              'options': [
                'Returned to Jerusalem',
                'Was baptized',
                'Wrote a letter to the churches',
                'Preached in the synagogue',
              ],
              'answer': 'Was baptized',
              'explanation':
                  'After receiving his sight and being filled with the Holy Spirit, Saul got up and was baptized right away.',
              'bibleReference': 'Acts 9:18',
            },
            {
              'question': 'Under which respected Jewish teacher had Saul been educated?',
              'options': [
                'Nicodemus',
                'Caiaphas',
                'Gamaliel',
                'Annas',
              ],
              'answer': 'Gamaliel',
              'explanation':
                  'Paul himself testified that he was educated under Gamaliel, a highly honored teacher of the law, and was thoroughly trained in the law of the ancestors.',
              'bibleReference': 'Acts 22:3',
            },
            {
              'question': 'What city was Saul originally from?',
              'options': [
                'Jerusalem',
                'Antioch',
                'Corinth',
                'Tarsus',
              ],
              'answer': 'Tarsus',
              'explanation':
                  'Saul was a native of Tarsus in Cilicia, a significant city in what is now southern Turkey.',
              'bibleReference': 'Acts 9:11',
            },
            {
              'question': 'From which tribe of Israel was Paul descended?',
              'options': [
                'Judah',
                'Levi',
                'Benjamin',
                'Ephraim',
              ],
              'answer': 'Benjamin',
              'explanation':
                  'Paul identified himself as a member of the tribe of Benjamin, a Hebrew of Hebrews, and a Pharisee.',
              'bibleReference': 'Philippians 3:5',
            },
          ],
        },
        // Chapter 2: Paul's First Missionary Journey
        {
          'id': 'first_journey',
          'title': 'Paul\'s First Missionary Journey',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'In the church at Antioch, while believers worshiped and fasted, the Holy Spirit spoke clearly: "Set apart for me Barnabas and Saul for the work to which I have called them." After prayer and fasting, the community laid hands on them and sent them off. This moment marked the beginning of organized Christian mission — the church deliberately commissioning and sending out its own to carry the gospel far beyond its walls.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Paul and Barnabas, accompanied by John Mark as their helper, sailed first to Cyprus — Barnabas\'s home island. There they encountered a sorcerer named Bar-Jesus, also called Elymas, who tried to turn the proconsul Sergius Paulus away from the faith. Paul, filled with the Spirit, confronted him sharply, and the man was struck blind. Witnessing this, the proconsul believed, amazed at the teaching about the Lord.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'From Cyprus the missionaries sailed on to Asia Minor, today\'s Turkey. In Pisidian Antioch, Paul preached powerfully in the synagogue, but Jewish leaders stirred up opposition and expelled them from the region. They pressed on to Iconium, then to Lystra, where they healed a man lame from birth — and the locals mistook them for gods! But opposition followed, and in Lystra Paul was stoned and left for dead, only to rise and continue his mission.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'After strengthening the disciples and appointing elders in every church they had planted, Paul and Barnabas retraced their steps and sailed back to Antioch in Syria. There they gathered the church together and reported all that God had done through them — how He had opened a door of faith to the Gentiles. This first journey had proved that the gospel was truly for all nations, not just the Jews.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'From which city were Paul and Barnabas officially commissioned for their first journey?',
              'options': [
                'Jerusalem',
                'Antioch',
                'Damascus',
                'Rome',
              ],
              'answer': 'Antioch',
              'explanation':
                  'The church at Antioch in Syria, directed by the Holy Spirit, set apart Barnabas and Saul and sent them off on their first missionary journey.',
              'bibleReference': 'Acts 13:1-3',
            },
            {
              'question': 'Who was Paul\'s primary companion on the first missionary journey?',
              'options': [
                'Silas',
                'Timothy',
                'Barnabas',
                'Luke',
              ],
              'answer': 'Barnabas',
              'explanation':
                  'Barnabas was chosen alongside Saul by the Holy Spirit and accompanied him throughout the first missionary journey.',
              'bibleReference': 'Acts 13:2',
            },
            {
              'question': 'In which city was Paul stoned and left for dead during the first journey?',
              'options': [
                'Iconium',
                'Lystra',
                'Derbe',
                'Perga',
              ],
              'answer': 'Lystra',
              'explanation':
                  'Jewish opponents from Antioch and Iconium won the crowd over and stoned Paul in Lystra, dragging him outside the city thinking he was dead.',
              'bibleReference': 'Acts 14:19',
            },
            {
              'question': 'Which island did Paul and Barnabas visit first on their missionary journey?',
              'options': [
                'Crete',
                'Malta',
                'Cyprus',
                'Rhodes',
              ],
              'answer': 'Cyprus',
              'explanation':
                  'Paul and Barnabas sailed from Seleucia to Cyprus as their first stop, where Barnabas himself was originally from.',
              'bibleReference': 'Acts 13:4',
            },
            {
              'question': 'What was a key distinguishing focus of Paul\'s first missionary journey?',
              'options': [
                'Planting churches only among Jews',
                'Bringing the gospel to Gentiles',
                'Establishing schools for children',
                'Collecting funds for Jerusalem',
              ],
              'answer': 'Bringing the gospel to Gentiles',
              'explanation':
                  'A significant outcome of the first journey was reaching Gentiles, which Paul and Barnabas reported to the Antioch church upon returning.',
              'bibleReference': 'Acts 14:27',
            },
            {
              'question': 'Who was John Mark in relation to the first missionary journey?',
              'options': [
                'A hostile synagogue leader',
                'A young helper who later left the team',
                'The proconsul of Cyprus',
                'A Gentile convert from Lystra',
              ],
              'answer': 'A young helper who later left the team',
              'explanation':
                  'John Mark joined Paul and Barnabas as a helper but departed from them at Pamphylia and did not continue with them to the work.',
              'bibleReference': 'Acts 13:5, 13',
            },
            {
              'question': 'What was the name of the sorcerer who opposed Paul on the island of Cyprus?',
              'options': [
                'Simon Magus',
                'Elymas',
                'Demetrius',
                'Alexander',
              ],
              'answer': 'Elymas',
              'explanation':
                  'Elymas, also called Bar-Jesus, was a Jewish sorcerer and false prophet who tried to turn the proconsul Sergius Paulus away from the faith.',
              'bibleReference': 'Acts 13:8',
            },
            {
              'question': 'What happened to Elymas the sorcerer after Paul confronted him?',
              'options': [
                'He was imprisoned',
                'He was struck blind',
                'He repented and was baptized',
                'He fled the island',
              ],
              'answer': 'He was struck blind',
              'explanation':
                  'Paul declared that the hand of the Lord was against Elymas, and immediately mist and darkness came over him and he groped around for someone to lead him.',
              'bibleReference': 'Acts 13:11',
            },
            {
              'question': 'Which city did Paul and Barnabas travel to after leaving Cyprus on the mainland?',
              'options': [
                'Ephesus',
                'Corinth',
                'Pisidian Antioch',
                'Thessalonica',
              ],
              'answer': 'Pisidian Antioch',
              'explanation':
                  'After Cyprus, Paul and his companions sailed to Perga and then traveled on to Pisidian Antioch, where Paul preached in the synagogue.',
              'bibleReference': 'Acts 13:14',
            },
            {
              'question': 'What did Paul and Barnabas report to the church in Antioch upon returning?',
              'options': [
                'That they had collected a great offering for the poor',
                'That God had opened a door of faith to the Gentiles',
                'That the Roman emperor had become favorable to Christians',
                'That all of Asia Minor had been baptized',
              ],
              'answer': 'That God had opened a door of faith to the Gentiles',
              'explanation':
                  'On their return, Paul and Barnabas gathered the church and reported all that God had done through them, especially how He had opened the door of faith to the Gentiles.',
              'bibleReference': 'Acts 14:27',
            },
          ],
        },
        // Chapter 3: Paul's Second Missionary Journey
        {
          'id': 'second_journey',
          'title': 'Paul\'s Second Missionary Journey',
          'difficulty': 'Medium',
          'timerEnabled': true,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'After the Jerusalem Council settled the question of Gentile salvation, Paul proposed returning to visit the churches from the first journey. When Paul and Barnabas sharply disagreed over taking John Mark again, they parted ways. Paul chose Silas as his new partner, and they set off through Syria and Cilicia. In Lystra they met a young disciple named Timothy, whose reputation was excellent. Paul wanted Timothy to join them, and Timothy became one of Paul\'s most trusted companions.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'The Spirit of Jesus prevented Paul from entering Asia or Bithynia, redirecting the team to Troas on the Aegean coast. There, in a night vision, Paul saw a man from Macedonia calling out, "Come over to Macedonia and help us!" Immediately the team concluded that God was calling them to preach the gospel in Europe. They crossed the sea and arrived at Philippi — a Roman colony and the leading city of Macedonia.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'In Philippi, by a riverside, they met Lydia — a dealer in purple cloth — whose heart the Lord opened, and she and her household were baptized. But trouble came: after Paul cast a spirit out of a slave girl, her owners had Paul and Silas beaten and thrown into prison. At midnight, the missionaries prayed and sang hymns. Suddenly a great earthquake shook the prison foundations, every door flew open, and the chains fell off every prisoner. The terrified jailer, thinking the prisoners had escaped, was about to kill himself when Paul cried out, "We are all here!"',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'The jailer rushed in trembling and asked Paul and Silas, "What must I do to be saved?" They replied, "Believe in the Lord Jesus, and you will be saved — you and your household." The jailer and his family were baptized that same night. From Philippi, Paul preached through Thessalonica, Berea, Athens — where he saw an altar inscribed "To an Unknown God" — and finally settled in Corinth for eighteen months, where he met fellow tentmakers Aquila and Priscilla.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Who was Paul\'s main traveling companion on the second missionary journey?',
              'options': [
                'Barnabas',
                'Timothy',
                'Silas',
                'Luke',
              ],
              'answer': 'Silas',
              'explanation':
                  'After the disagreement with Barnabas over John Mark, Paul chose Silas as his new companion and they left Antioch together.',
              'bibleReference': 'Acts 15:40',
            },
            {
              'question': 'In which city did Timothy join Paul\'s missionary team?',
              'options': [
                'Antioch',
                'Philippi',
                'Lystra',
                'Derbe',
              ],
              'answer': 'Lystra',
              'explanation':
                  'Timothy, a disciple well spoken of by the believers in Lystra and Iconium, joined Paul when the team came through Lystra.',
              'bibleReference': 'Acts 16:1-3',
            },
            {
              'question': 'What vision directed Paul to go to Macedonia?',
              'options': [
                'An angel standing over the Aegean Sea',
                'A man from Macedonia pleading for help',
                'A vision of the Roman Emperor welcoming him',
                'A burning bush on the coast of Troas',
              ],
              'answer': 'A man from Macedonia pleading for help',
              'explanation':
                  'During the night Paul had a vision of a man from Macedonia standing and begging him, "Come over to Macedonia and help us."',
              'bibleReference': 'Acts 16:9',
            },
            {
              'question': 'What was the first European city Paul preached in during the second journey?',
              'options': [
                'Athens',
                'Corinth',
                'Thessalonica',
                'Philippi',
              ],
              'answer': 'Philippi',
              'explanation':
                  'After crossing from Troas to Macedonia, Paul\'s team went to Philippi, a leading city of the district of Macedonia and a Roman colony.',
              'bibleReference': 'Acts 16:12',
            },
            {
              'question': 'What was the occupation of Lydia, the first recorded European convert?',
              'options': [
                'A weaver of fine linen',
                'A seller of purple cloth',
                'A potter who made jars',
                'A baker in the marketplace',
              ],
              'answer': 'A seller of purple cloth',
              'explanation':
                  'Lydia was from the city of Thyatira and was a dealer in purple cloth. The Lord opened her heart to respond to Paul\'s message.',
              'bibleReference': 'Acts 16:14',
            },
            {
              'question': 'What miraculous event occurred while Paul and Silas were in the Philippian prison?',
              'options': [
                'An angel appeared and carried them out',
                'A violent earthquake opened all the doors',
                'The prison walls turned to water',
                'A great fire consumed the chains',
              ],
              'answer': 'A violent earthquake opened all the doors',
              'explanation':
                  'About midnight, while Paul and Silas were praying and singing, a violent earthquake shook the prison foundations, all the doors flew open, and everyone\'s chains came loose.',
              'bibleReference': 'Acts 16:26',
            },
            {
              'question': 'What unusual thing did Paul observe in Athens?',
              'options': [
                'A statue of Caesar calling himself god',
                'An altar with the inscription "To an Unknown God"',
                'A temple where Christians were secretly meeting',
                'A marketplace where all idols had been destroyed',
              ],
              'answer': 'An altar with the inscription "To an Unknown God"',
              'explanation':
                  'While walking around Athens, Paul found an altar with the inscription "To an Unknown God," which he used as a starting point to preach about Jesus.',
              'bibleReference': 'Acts 17:23',
            },
            {
              'question': 'How long did Paul remain in Corinth on his second journey?',
              'options': [
                '3 months',
                '6 months',
                '18 months',
                '3 years',
              ],
              'answer': '18 months',
              'explanation':
                  'Paul stayed in Corinth for a year and a half, teaching the word of God among the people there.',
              'bibleReference': 'Acts 18:11',
            },
            {
              'question': 'What did Paul have in common with Aquila and Priscilla that led to their close friendship?',
              'options': [
                'They were all from Tarsus',
                'They were all tentmakers',
                'They had all studied under Gamaliel',
                'They had all been imprisoned for their faith',
              ],
              'answer': 'They were all tentmakers',
              'explanation':
                  'Because he was a tentmaker as they were, Paul stayed and worked with Aquila and Priscilla in Corinth.',
              'bibleReference': 'Acts 18:3',
            },
            {
              'question': 'Why did Paul and Barnabas separate before the second journey began?',
              'options': [
                'Barnabas wanted to go to Rome instead',
                'They disagreed sharply over taking John Mark',
                'The Jerusalem Council assigned them different regions',
                'Barnabas fell ill and could not travel',
              ],
              'answer': 'They disagreed sharply over taking John Mark',
              'explanation':
                  'Barnabas wanted to take John Mark, but Paul did not think it wise to take someone who had deserted them on the first journey, causing such a sharp disagreement that they parted.',
              'bibleReference': 'Acts 15:37-39',
            },
          ],
        },
        // Chapter 4: Paul's Third Missionary Journey
        {
          'id': 'third_journey',
          'title': 'Paul\'s Third Missionary Journey',
          'difficulty': 'Hard',
          'timerEnabled': true,
          'timerDurationSeconds': 25,
          'requiredCorrect': 7,
          'narratives': [
            {
              'text':
                  'Paul\'s third journey took him to Ephesus, the great commercial city on the Aegean coast, where he stayed longer than anywhere else in his travels. For about three years he taught daily in the lecture hall of Tyrannus, so that all the Jews and Greeks in the province of Asia heard the word of the Lord. His ministry was accompanied by extraordinary miracles — even handkerchiefs and aprons that had touched him were brought to the sick and they were healed.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Ephesus was home to the magnificent temple of Artemis, one of the seven wonders of the ancient world. A silversmith named Demetrius, who made silver shrines of Artemis, gathered his fellow craftsmen and stirred up a riot. "This Paul has persuaded large numbers of people that man-made gods are no gods at all," he cried. His real concern was financial — the gospel was costing him business. The city erupted into uproar, with crowds shouting "Great is Artemis of the Ephesians!" for two solid hours.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'After the riot settled, Paul traveled through Macedonia and Greece before making his way back to Jerusalem. In Troas, during a long farewell gathering that stretched past midnight, a young man named Eutychus fell asleep in a third-story window and plunged to his death. Paul went down, threw himself on the young man, and embraced him — and life returned to him. The community was overjoyed and greatly comforted.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'In Miletus, Paul called the elders of the Ephesian church to meet him for a final farewell. With great emotion he reminded them of his faithful service among them and warned that after his departure, savage wolves would come and distort the truth. "I consider my life worth nothing to me," he declared, "my only aim is to finish the race and complete the task the Lord Jesus has given me." He knelt and prayed with them all, and there was much weeping.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Approximately how long did Paul stay and minister in Ephesus?',
              'options': [
                '6 months',
                '1 year',
                'About 3 years',
                '5 years',
              ],
              'answer': 'About 3 years',
              'explanation':
                  'Paul spent approximately three years in Ephesus, longer than any other city in his travels, teaching in the hall of Tyrannus so the whole province of Asia heard the gospel.',
              'bibleReference': 'Acts 20:31',
            },
            {
              'question': 'Who instigated the riot against Paul in Ephesus?',
              'options': [
                'The high priest\'s messenger',
                'Demetrius the silversmith',
                'Alexander the metalworker',
                'The city treasurer',
              ],
              'answer': 'Demetrius the silversmith',
              'explanation':
                  'Demetrius, a silversmith who made silver shrines of Artemis, gathered his fellow craftsmen and stirred up a riot against Paul.',
              'bibleReference': 'Acts 19:24',
            },
            {
              'question': 'What was the underlying reason for the riot in Ephesus?',
              'options': [
                'Paul had desecrated the temple of Artemis',
                'Paul\'s preaching was hurting the silver shrine business',
                'Paul had healed a rival of Demetrius',
                'Paul refused to pay the required temple tax',
              ],
              'answer': 'Paul\'s preaching was hurting the silver shrine business',
              'explanation':
                  'Demetrius warned that Paul\'s teaching that man-made gods are not gods had persuaded many, which was threatening their trade in Artemis shrines.',
              'bibleReference': 'Acts 19:26-27',
            },
            {
              'question': 'Who fell from a window during Paul\'s long night meeting in Troas?',
              'options': [
                'Trophimus',
                'Tychicus',
                'Eutychus',
                'Epaphras',
              ],
              'answer': 'Eutychus',
              'explanation':
                  'A young man named Eutychus, who was sitting in a window, sank into a deep sleep as Paul talked on and fell from the third floor.',
              'bibleReference': 'Acts 20:9',
            },
            {
              'question': 'What happened to Eutychus after he fell from the window?',
              'options': [
                'He was badly injured but survived',
                'He remained in a coma for three days',
                'Paul raised him from the dead',
                'He was healed after the congregation prayed',
              ],
              'answer': 'Paul raised him from the dead',
              'explanation':
                  'Eutychus was picked up dead, but Paul went down, threw himself on him, and announced that life was in him — he was raised.',
              'bibleReference': 'Acts 20:10',
            },
            {
              'question': 'Who did Paul summon to Miletus for a final farewell address?',
              'options': [
                'All the believers in Macedonia',
                'The seven churches of Asia',
                'The elders of the church in Ephesus',
                'His co-workers Silas and Timothy',
              ],
              'answer': 'The elders of the church in Ephesus',
              'explanation':
                  'From Miletus, Paul sent to Ephesus and called for the elders of the church, delivering to them his heartfelt farewell speech.',
              'bibleReference': 'Acts 20:17',
            },
            {
              'question': 'What danger did Paul warn the Ephesian elders would come after his departure?',
              'options': [
                'Roman soldiers would arrest them all',
                'Savage wolves would distort the truth and scatter the flock',
                'A great earthquake would destroy Ephesus',
                'Famine would drive them away from the city',
              ],
              'answer': 'Savage wolves would distort the truth and scatter the flock',
              'explanation':
                  'Paul warned that after he left, savage wolves would come in among them and not spare the flock, and even from among their own number people would arise and distort the truth.',
              'bibleReference': 'Acts 20:29-30',
            },
            {
              'question': 'What did Paul say about his own life in his farewell speech at Miletus?',
              'options': [
                'He considered his life worth nothing to him',
                'He hoped to live long enough to see Rome',
                'He wished he could stay in Ephesus forever',
                'He believed he would escape all harm',
              ],
              'answer': 'He considered his life worth nothing to him',
              'explanation':
                  'Paul declared that he considered his life worth nothing to himself, as his only aim was to finish the race and complete the task of testifying to the gospel of God\'s grace.',
              'bibleReference': 'Acts 20:24',
            },
            {
              'question': 'Which of Paul\'s letters was written from Ephesus during the third journey?',
              'options': [
                'Galatians',
                'Romans',
                '1 Corinthians',
                'Colossians',
              ],
              'answer': '1 Corinthians',
              'explanation':
                  'Paul wrote 1 Corinthians while in Ephesus, mentioning that he planned to stay there until Pentecost.',
              'bibleReference': '1 Corinthians 16:8',
            },
            {
              'question': 'What trade did Paul practice to support himself during his missionary work?',
              'options': [
                'Carpentry',
                'Tentmaking',
                'Fishing',
                'Pottery',
              ],
              'answer': 'Tentmaking',
              'explanation':
                  'Paul was a tentmaker by trade and used this skill to earn his own living rather than being a burden to the churches he served.',
              'bibleReference': 'Acts 18:3',
            },
          ],
        },
        // Chapter 5: Paul in Prison
        {
          'id': 'paul_in_prison',
          'title': 'Paul in Prison',
          'difficulty': 'Hard',
          'timerEnabled': true,
          'timerDurationSeconds': 25,
          'requiredCorrect': 7,
          'narratives': [
            {
              'text':
                  'Paul\'s return to Jerusalem ended in arrest. A mob seized him in the temple, accusing him of defiling the holy place. Roman soldiers rescued him from the crowd, but he remained under Roman custody. He was transferred to Caesarea, where he stood before Governor Felix, then Festus, and finally King Agrippa — each time defending his faith and his encounter with the risen Jesus. Before Agrippa, Paul made such a powerful case that the king replied, "Do you think that in such a short time you can persuade me to be a Christian?"',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'To secure a fair hearing and escape Jewish plots, Paul exercised his right as a Roman citizen and appealed to Caesar. This meant a voyage to Rome. The journey was treacherous — a massive storm battered the ship for two weeks. An angel assured Paul that he must stand before Caesar and that God had granted the lives of all 276 people on board. The ship ran aground near the island of Malta and broke apart, but every person reached shore safely, just as God had promised.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'On Malta, the islanders showed extraordinary kindness. As Paul gathered firewood, a viper fastened itself to his hand. The locals expected him to swell up and die, but Paul simply shook the snake off into the fire and suffered no ill effects. They changed their minds and said he was a god. Paul also healed the father of the leading official on the island, and the rest of the sick on Malta came and were healed.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Paul eventually reached Rome and lived there under house arrest for two years, welcoming all who came to him and boldly preaching the kingdom of God. During this time of imprisonment he wrote letters full of joy and deep theology — to the Philippians, Ephesians, Colossians, and to Philemon — letters that would shape Christian thought for centuries. From a prison cell, the man who had once imprisoned Christians wrote of contentment, peace, and the surpassing greatness of knowing Christ Jesus.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Who was Paul\'s companion who was with him when they were imprisoned in Philippi?',
              'options': [
                'Timothy',
                'Barnabas',
                'Silas',
                'Luke',
              ],
              'answer': 'Silas',
              'explanation':
                  'Silas was imprisoned alongside Paul in Philippi after they cast a fortune-telling spirit out of a slave girl.',
              'bibleReference': 'Acts 16:25',
            },
            {
              'question': 'What were Paul and Silas doing at midnight while in the Philippian jail?',
              'options': [
                'Sleeping soundly despite their chains',
                'Praying and singing hymns to God',
                'Writing letters to the churches',
                'Planning their escape route',
              ],
              'answer': 'Praying and singing hymns to God',
              'explanation':
                  'About midnight Paul and Silas were praying and singing hymns to God, and the other prisoners were listening to them.',
              'bibleReference': 'Acts 16:25',
            },
            {
              'question': 'What happened in the Philippian prison that led to the jailer\'s conversion?',
              'options': [
                'A fire destroyed the prison walls',
                'An earthquake opened the doors and loosened the chains',
                'An angel appeared and led them out',
                'A flood filled the prison and washed away the bars',
              ],
              'answer': 'An earthquake opened the doors and loosened the chains',
              'explanation':
                  'A violent earthquake shook the foundations of the prison, all the doors flew open, and everyone\'s chains came loose.',
              'bibleReference': 'Acts 16:26',
            },
            {
              'question': 'What question did the Philippian jailer ask Paul and Silas?',
              'options': [
                'Who gave you the power to do these miracles?',
                'What must I do to be saved?',
                'Will you heal my family as you have healed others?',
                'How can I join your missionary team?',
              ],
              'answer': 'What must I do to be saved?',
              'explanation':
                  'The terrified jailer fell trembling before Paul and Silas and asked, "Sirs, what must I do to be saved?"',
              'bibleReference': 'Acts 16:30',
            },
            {
              'question': 'Which of the following is one of Paul\'s "prison epistles" written during his Roman imprisonment?',
              'options': [
                '1 Corinthians',
                'Galatians',
                'Philippians',
                '1 Thessalonians',
              ],
              'answer': 'Philippians',
              'explanation':
                  'Philippians is one of the four "prison epistles" Paul wrote during his Roman imprisonment, along with Ephesians, Colossians, and Philemon.',
              'bibleReference': 'Philippians 1:13',
            },
            {
              'question': 'On which island was Paul shipwrecked while sailing to Rome?',
              'options': [
                'Cyprus',
                'Crete',
                'Malta',
                'Rhodes',
              ],
              'answer': 'Malta',
              'explanation':
                  'After the ship ran aground and broke apart in a storm, Paul and all 276 people on board reached the shore of the island of Malta.',
              'bibleReference': 'Acts 28:1',
            },
            {
              'question': 'What creature attacked Paul on the island of Malta?',
              'options': [
                'A scorpion',
                'A viper',
                'A wild dog',
                'A hornet',
              ],
              'answer': 'A viper',
              'explanation':
                  'As Paul gathered wood for a fire on Malta, a viper driven out by the heat fastened itself on his hand, but he shook it into the fire and suffered no ill effects.',
              'bibleReference': 'Acts 28:3',
            },
            {
              'question': 'Before which king did Paul say "You are almost persuading me to become a Christian" was directed back at Paul?',
              'options': [
                'Felix',
                'Festus',
                'Agrippa',
                'Herod',
              ],
              'answer': 'Agrippa',
              'explanation':
                  'After hearing Paul\'s defense, King Agrippa said, "Do you think that in such a short time you can persuade me to be a Christian?" to which Paul replied he wished Agrippa and all present could become what he was.',
              'bibleReference': 'Acts 26:28',
            },
            {
              'question': 'How did Paul secure his transfer from Jerusalem to Rome for trial?',
              'options': [
                'He bribed the governor Felix',
                'He appealed to Caesar as a Roman citizen',
                'The Jerusalem church sent him as an ambassador',
                'A Roman commander ordered him to Rome',
              ],
              'answer': 'He appealed to Caesar as a Roman citizen',
              'explanation':
                  'Paul exercised his right as a Roman citizen by appealing to Caesar, which meant his case had to be heard in Rome.',
              'bibleReference': 'Acts 25:11',
            },
            {
              'question': 'What did Paul write about contentment in his letter to the Philippians?',
              'options': [
                'Contentment is a gift only given to the apostles',
                'I have learned to be content in whatever circumstances I am in',
                'True contentment is found only in earthly peace',
                'Contentment comes from having all your needs met',
              ],
              'answer': 'I have learned to be content in whatever circumstances I am in',
              'explanation':
                  'Paul wrote that he had learned the secret of contentment — to be content in all circumstances, whether in need or in plenty.',
              'bibleReference': 'Philippians 4:11',
            },
          ],
        },
      ],
    },
    // Arc 4: The Life of Joseph
    {
      'id': 'life_of_joseph',
      'title': 'The Life of Joseph',
      'description':
          'From his father\'s favorite son to a slave in Egypt to the most powerful man after Pharaoh — discover how God turned betrayal and suffering into salvation for an entire nation.',
      'chapters': [
        // Chapter 1: The Dreamer
        {
          'id': 'joseph_dreamer',
          'title': 'The Dreamer',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'Jacob had twelve sons, but Joseph was his favorite — the firstborn of his beloved wife Rachel. Jacob made no secret of this preference, giving Joseph a richly ornamented robe that set him apart from his brothers. The other sons watched and seethed. Joseph\'s favored status was plain for all to see, and it bred deep resentment in his older brothers, who could not speak a kind word to him.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Joseph began to have vivid, unusual dreams — and he made the mistake of sharing them with his family. In the first dream, his sheaf of grain stood upright while his brothers\' sheaves bowed down around it. His brothers, furious, asked, "Do you intend to reign over us?" In the second dream, the sun, moon, and eleven stars were bowing down to Joseph. Even his father rebuked him this time, though Jacob quietly pondered what it all might mean.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'One day Jacob sent Joseph to check on his brothers who were grazing the flocks. The brothers saw him coming from a distance and plotted against him. "Here comes that dreamer!" they said. They seized him, stripped off his robe, and threw him into an empty cistern. When a caravan of Ishmaelite traders passed by, it was Judah who proposed selling Joseph rather than killing him. And so Joseph was sold for twenty pieces of silver.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'To cover their crime, the brothers slaughtered a goat and dipped Joseph\'s special robe in the blood. They brought it to their father Jacob and said, "We found this — see if it is your son\'s robe." Jacob recognized it immediately. "A ferocious animal has devoured him!" he cried, and tore his own clothes in grief. He mourned his son for many days and refused to be comforted, while Joseph — unknown to his father — was being sold as a slave in the land of Egypt.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Who was Joseph\'s father?',
              'options': [
                'Abraham',
                'Isaac',
                'Jacob',
                'Judah',
              ],
              'answer': 'Jacob',
              'explanation':
                  'Joseph was the son of Jacob, also called Israel, born to him by his beloved wife Rachel.',
              'bibleReference': 'Genesis 37:3',
            },
            {
              'question': 'What special gift did Jacob give to Joseph as a sign of his special affection?',
              'options': [
                'A gold ring from Egypt',
                'A coat of many colors',
                'The firstborn\'s double portion of land',
                'A white donkey for traveling',
              ],
              'answer': 'A coat of many colors',
              'explanation':
                  'Jacob made a richly ornamented robe (often called a coat of many colors) for Joseph, which signaled to all the brothers that Joseph was specially loved.',
              'bibleReference': 'Genesis 37:3',
            },
            {
              'question': 'How many brothers did Joseph have?',
              'options': [
                '7',
                '9',
                '10',
                '11',
              ],
              'answer': '11',
              'explanation':
                  'Joseph had eleven brothers, making him one of twelve sons of Jacob. His second dream featured eleven stars (representing his brothers) bowing down to him.',
              'bibleReference': 'Genesis 37:9',
            },
            {
              'question': 'What did Joseph\'s first dream involve?',
              'options': [
                'Seven fat cows and seven thin cows',
                'Sheaves of grain bowing before his sheaf',
                'Stars falling from heaven',
                'A great river flowing through Egypt',
              ],
              'answer': 'Sheaves of grain bowing before his sheaf',
              'explanation':
                  'In the first dream, Joseph and his brothers were binding sheaves of grain when his sheaf rose and stood upright while his brothers\' sheaves gathered around and bowed down to it.',
              'bibleReference': 'Genesis 37:6-7',
            },
            {
              'question': 'What did Joseph\'s second dream depict?',
              'options': [
                'A stairway reaching to heaven',
                'Seven years of plenty and famine',
                'The sun, moon, and eleven stars bowing to him',
                'A great tree providing shade for all nations',
              ],
              'answer': 'The sun, moon, and eleven stars bowing to him',
              'explanation':
                  'In the second dream, the sun, moon, and eleven stars were bowing down to Joseph, which his father interpreted as symbolizing Joseph\'s parents and brothers bowing before him.',
              'bibleReference': 'Genesis 37:9',
            },
            {
              'question': 'Which of Joseph\'s brothers suggested selling him to the Ishmaelite traders?',
              'options': [
                'Reuben',
                'Simeon',
                'Judah',
                'Levi',
              ],
              'answer': 'Judah',
              'explanation':
                  'It was Judah who said to his brothers, "What will we gain if we kill our brother and cover up his blood? Come, let\'s sell him to the Ishmaelites."',
              'bibleReference': 'Genesis 37:26-27',
            },
            {
              'question': 'How old was Joseph when his brothers sold him?',
              'options': [
                '12',
                '15',
                '17',
                '20',
              ],
              'answer': '17',
              'explanation':
                  'Joseph was seventeen years old when he was sold into slavery by his brothers.',
              'bibleReference': 'Genesis 37:2',
            },
            {
              'question': 'What story did the brothers tell their father to explain Joseph\'s disappearance?',
              'options': [
                'That he had run away to Egypt on his own',
                'That a ferocious wild animal had killed him',
                'That he had drowned crossing a river',
                'That enemies had kidnapped him during a raid',
              ],
              'answer': 'That a ferocious wild animal had killed him',
              'explanation':
                  'The brothers showed Jacob the blood-dipped robe, letting him conclude that a ferocious animal had devoured Joseph.',
              'bibleReference': 'Genesis 37:33',
            },
            {
              'question': 'What did the brothers use to make it appear that Joseph was dead?',
              'options': [
                'Sheep\'s blood on his sandals',
                'Goat\'s blood on his robe',
                'Ox blood on a piece of cloth',
                'Red berries crushed onto his tunic',
              ],
              'answer': 'Goat\'s blood on his robe',
              'explanation':
                  'The brothers slaughtered a goat and dipped Joseph\'s ornate robe in the blood, then brought it to Jacob as \'evidence\' that Joseph had been killed.',
              'bibleReference': 'Genesis 37:31',
            },
            {
              'question': 'Who was Joseph\'s mother?',
              'options': [
                'Leah',
                'Zilpah',
                'Bilhah',
                'Rachel',
              ],
              'answer': 'Rachel',
              'explanation':
                  'Joseph was the son of Rachel, Jacob\'s beloved wife, which contributed significantly to Jacob\'s special love for him.',
              'bibleReference': 'Genesis 30:24',
            },
          ],
        },
        // Chapter 2: Sold into Slavery
        {
          'id': 'joseph_slavery',
          'title': 'Sold into Slavery',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'Joseph arrived in Egypt as a slave and was sold to Potiphar, one of Pharaoh\'s officials — the captain of the guard. Yet the hand of God was unmistakably on Joseph. Everything he touched prospered. Potiphar noticed that the Lord was with Joseph and that the Lord gave him success in everything he did. Potiphar\'s trust grew until he made Joseph overseer of his entire household, putting everything he owned into Joseph\'s care.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Joseph was well-built and handsome, and Potiphar\'s wife began to take notice. Day after day she pressured Joseph, "Come to bed with me!" Day after day Joseph refused. "How could I do this wicked thing and sin against God?" he asked. One day, when no one else was in the house, she grabbed his cloak and demanded again. Joseph fled, leaving his cloak in her hand. Furious and humiliated, she used the cloak as evidence and falsely accused Joseph of attacking her.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Potiphar\'s anger burned and he had Joseph thrown into prison — the place where the king\'s prisoners were confined. Yet even there, the Lord was with Joseph and showed him kindness. The prison warden put Joseph in charge of all the other prisoners. Two of Pharaoh\'s officials — the chief cupbearer and the chief baker — were thrown into the same prison, and Joseph was assigned to attend to them.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'One morning Joseph noticed the two officials looking dejected and asked them why. "We each had a dream last night," they said, "and there is no one to interpret it." Joseph replied, "Do not interpretations belong to God? Tell me your dreams." He interpreted the cupbearer\'s dream as meaning he would be restored to his position in three days, and the baker\'s dream as meaning he would be executed. Both came true exactly as Joseph had said — but the cupbearer, restored to his place, promptly forgot all about Joseph for two full years.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'To whom was Joseph sold when he arrived in Egypt?',
              'options': [
                'Pharaoh\'s chief advisor',
                'Potiphar',
                'The temple priest of Amun',
                'A merchant in the marketplace',
              ],
              'answer': 'Potiphar',
              'explanation':
                  'Joseph was sold to Potiphar, one of Pharaoh\'s officials, by the Ishmaelite traders who had bought him from his brothers.',
              'bibleReference': 'Genesis 39:1',
            },
            {
              'question': 'What was Potiphar\'s official role?',
              'options': [
                'Pharaoh\'s chief treasurer',
                'Captain of Pharaoh\'s guard',
                'Head of the royal stables',
                'Chief judge of Egypt',
              ],
              'answer': 'Captain of Pharaoh\'s guard',
              'explanation':
                  'Potiphar was an Egyptian who served as one of Pharaoh\'s officials and the captain of the guard.',
              'bibleReference': 'Genesis 39:1',
            },
            {
              'question': 'Why did Joseph succeed in everything he did in Potiphar\'s house?',
              'options': [
                'He had been educated in all the wisdom of Egypt',
                'The Lord was with him and gave him success',
                'Potiphar paid him well and he worked hard',
                'He had natural talent for management',
              ],
              'answer': 'The Lord was with him and gave him success',
              'explanation':
                  'Scripture repeatedly emphasizes that the key to Joseph\'s success was that the Lord was with him and gave him success in whatever he did.',
              'bibleReference': 'Genesis 39:3',
            },
            {
              'question': 'Who falsely accused Joseph and had him imprisoned?',
              'options': [
                'Potiphar himself, out of jealousy',
                'Potiphar\'s wife',
                'A jealous fellow servant',
                'The chief baker',
              ],
              'answer': 'Potiphar\'s wife',
              'explanation':
                  'Potiphar\'s wife, after Joseph repeatedly refused her advances, falsely accused him of attacking her using his cloak as false evidence.',
              'bibleReference': 'Genesis 39:14-18',
            },
            {
              'question': 'Where was Joseph sent after being falsely accused?',
              'options': [
                'He was sent back to Canaan',
                'He was sent to work in the mines',
                'He was put in the royal prison',
                'He was sold to another household',
              ],
              'answer': 'He was put in the royal prison',
              'explanation':
                  'Joseph was thrown into the prison where the king\'s prisoners were confined, but even there the Lord was with him.',
              'bibleReference': 'Genesis 39:20',
            },
            {
              'question': 'What role did Joseph come to have in the prison?',
              'options': [
                'He guarded the outer gate',
                'He was put in charge of all the other prisoners',
                'He served as the warden\'s personal scribe',
                'He worked in the prison kitchen',
              ],
              'answer': 'He was put in charge of all the other prisoners',
              'explanation':
                  'The prison warden put Joseph in charge of all those held in the prison, and the warden paid no attention to anything under Joseph\'s care because the Lord was with Joseph.',
              'bibleReference': 'Genesis 39:22',
            },
            {
              'question': 'Whose dreams did Joseph interpret while he was in prison?',
              'options': [
                'Pharaoh\'s dreams about cattle and grain',
                'The prison warden\'s recurring nightmares',
                'The chief cupbearer\'s and the chief baker\'s dreams',
                'His own prophetic dreams about the future',
              ],
              'answer': 'The chief cupbearer\'s and the chief baker\'s dreams',
              'explanation':
                  'Two of Pharaoh\'s officials — the chief cupbearer and the chief baker — were imprisoned and each had a dream on the same night that Joseph interpreted.',
              'bibleReference': 'Genesis 40:5-8',
            },
            {
              'question': 'What happened to the chief cupbearer after Joseph interpreted his dream?',
              'options': [
                'He was executed',
                'He remained in prison indefinitely',
                'He was restored to his position serving Pharaoh',
                'He was sent as a slave to another country',
              ],
              'answer': 'He was restored to his position serving Pharaoh',
              'explanation':
                  'Just as Joseph had interpreted, within three days Pharaoh restored the chief cupbearer to his position and he once again put the cup in Pharaoh\'s hand.',
              'bibleReference': 'Genesis 40:21',
            },
            {
              'question': 'What happened to the chief baker after Joseph interpreted his dream?',
              'options': [
                'He was released and returned to his hometown',
                'He was given a promotion in the palace',
                'He was executed',
                'He remained in prison for years',
              ],
              'answer': 'He was executed',
              'explanation':
                  'Joseph interpreted the baker\'s dream as meaning he would be hanged within three days, and this came true exactly as predicted.',
              'bibleReference': 'Genesis 40:22',
            },
            {
              'question': 'How long did the chief cupbearer forget about Joseph after being restored?',
              'options': [
                '3 months',
                '1 year',
                '2 years',
                '7 years',
              ],
              'answer': '2 years',
              'explanation':
                  'The chief cupbearer did not remember Joseph and forgot him entirely for two full years, until Pharaoh had his disturbing dreams.',
              'bibleReference': 'Genesis 41:1',
            },
          ],
        },
        // Chapter 3: Rise in Egypt
        {
          'id': 'joseph_rise',
          'title': 'Rise in Egypt',
          'difficulty': 'Medium',
          'timerEnabled': true,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'Two years after the cupbearer\'s restoration, Pharaoh had two deeply troubling dreams that no one in all of Egypt could interpret. The cupbearer finally remembered Joseph and told Pharaoh about the dream interpreter in the prison. Joseph was quickly brought before Pharaoh — he shaved, changed his clothes, and stood before the most powerful man on earth. "I cannot interpret dreams," Joseph said humbly, "but God will give Pharaoh the answer he desires."',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Pharaoh described his dreams: seven fat, healthy cows devoured by seven ugly, gaunt cows — and still the thin ones looked just as they had before. Then seven full, healthy heads of grain were swallowed up by seven thin, scorched heads. Joseph explained that the two dreams were one message from God: seven years of great abundance would come throughout Egypt, followed by seven years of severe famine that would wipe out all the abundance. The famine would be so devastating that the plenty would be forgotten.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Joseph advised Pharaoh to appoint a wise man to oversee a massive grain storage operation during the years of plenty. Pharaoh turned to his officials and said, "Can we find anyone like this man, one in whom is the spirit of God?" He said to Joseph: "Since God has made all this known to you, there is no one so discerning and wise as you. You shall be in charge of my palace, and all my people are to submit to your orders." Pharaoh placed his own signet ring on Joseph\'s finger, dressed him in fine linen, and put a gold chain around his neck.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Joseph was thirty years old when he entered Pharaoh\'s service. He was given an Egyptian name — Zaphenath-Paneah — and an Egyptian wife, Asenath. During the seven years of abundance, Joseph collected enormous quantities of grain and stored it throughout Egypt. Two sons were born to him: he named the firstborn Manasseh, saying "God has made me forget all my trouble," and the second Ephraim, saying "God has made me fruitful in the land of my suffering."',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'What did Pharaoh see in his first dream?',
              'options': [
                'Seven stars falling from the sky',
                'Seven fat cows eaten by seven thin cows',
                'Seven jars of grain spilling onto the Nile',
                'Seven priests bowing before a foreign god',
              ],
              'answer': 'Seven fat cows eaten by seven thin cows',
              'explanation':
                  'In the first dream, Pharaoh saw seven sleek, fat cows come up from the Nile, followed by seven ugly, gaunt cows that devoured the fat ones.',
              'bibleReference': 'Genesis 41:2-4',
            },
            {
              'question': 'What did Pharaoh\'s second dream involve?',
              'options': [
                'Seven lampstands being extinguished by wind',
                'A great river drying up completely',
                'Seven healthy heads of grain swallowed by seven thin heads',
                'Seven mountains crumbling into the sea',
              ],
              'answer': 'Seven healthy heads of grain swallowed by seven thin heads',
              'explanation':
                  'In the second dream, seven full, healthy heads of grain grew on a single stalk but were swallowed up by seven thin, scorched heads.',
              'bibleReference': 'Genesis 41:5-7',
            },
            {
              'question': 'What did Joseph say Pharaoh\'s two dreams meant?',
              'options': [
                'Egypt would conquer its enemies, then face a revolt',
                'The Nile would flood for seven years, then dry up',
                'Seven years of abundance would be followed by seven years of famine',
                'Seven pharaohs would rule before Egypt was destroyed',
              ],
              'answer': 'Seven years of abundance would be followed by seven years of famine',
              'explanation':
                  'Joseph explained that both dreams carried one message: God was showing Pharaoh what He was about to do — seven years of great abundance throughout Egypt, followed by seven years of severe famine.',
              'bibleReference': 'Genesis 41:28-30',
            },
            {
              'question': 'How old was Joseph when he stood before Pharaoh and was appointed ruler?',
              'options': [
                '25',
                '28',
                '30',
                '35',
              ],
              'answer': '30',
              'explanation':
                  'Joseph was thirty years old when he entered the service of Pharaoh king of Egypt.',
              'bibleReference': 'Genesis 41:46',
            },
            {
              'question': 'What Egyptian name was Joseph given by Pharaoh?',
              'options': [
                'Imhotep',
                'Akenaten',
                'Zaphenath-Paneah',
                'Rameses',
              ],
              'answer': 'Zaphenath-Paneah',
              'explanation':
                  'Pharaoh gave Joseph the Egyptian name Zaphenath-Paneah when he elevated him to his position of authority.',
              'bibleReference': 'Genesis 41:45',
            },
            {
              'question': 'Who was Joseph\'s Egyptian wife?',
              'options': [
                'Miriam',
                'Asenath',
                'Zipporah',
                'Nefertiti',
              ],
              'answer': 'Asenath',
              'explanation':
                  'Pharaoh gave Joseph Asenath, the daughter of Potiphera the priest of On, to be his wife.',
              'bibleReference': 'Genesis 41:45',
            },
            {
              'question': 'What were the names of Joseph\'s two sons?',
              'options': [
                'Gad and Asher',
                'Perez and Zerah',
                'Manasseh and Ephraim',
                'Reuben and Simeon',
              ],
              'answer': 'Manasseh and Ephraim',
              'explanation':
                  'Joseph named his firstborn Manasseh and his second son Ephraim, names reflecting God\'s faithfulness in his suffering and fruitfulness.',
              'bibleReference': 'Genesis 41:51-52',
            },
            {
              'question': 'What was Joseph\'s official role in Egypt after Pharaoh promoted him?',
              'options': [
                'Chief military commander',
                'High priest of the temple',
                'Second in command over all of Egypt',
                'Royal treasurer and tax collector',
              ],
              'answer': 'Second in command over all of Egypt',
              'explanation':
                  'Pharaoh put Joseph in charge of the whole land of Egypt, making him second only to Pharaoh himself.',
              'bibleReference': 'Genesis 41:40-41',
            },
            {
              'question': 'What did Joseph collect and store during the seven years of plenty?',
              'options': [
                'Gold and silver for the royal treasury',
                'Grain and food from the land',
                'Weapons for the Egyptian army',
                'Papyrus scrolls in the royal library',
              ],
              'answer': 'Grain and food from the land',
              'explanation':
                  'Joseph traveled throughout Egypt and collected all the food produced in those seven years of abundance and stored it in the cities.',
              'bibleReference': 'Genesis 41:48',
            },
            {
              'question': 'What symbolic item did Pharaoh place on Joseph\'s finger when promoting him?',
              'options': [
                'A jeweled armband from the Nile',
                'His own signet ring',
                'A golden ring from the temple treasury',
                'A ceremonial ring from the high priest',
              ],
              'answer': 'His own signet ring',
              'explanation':
                  'Pharaoh took his signet ring from his own finger and put it on Joseph\'s finger, along with fine linen robes and a gold chain.',
              'bibleReference': 'Genesis 41:42',
            },
          ],
        },
        // Chapter 4: Reunion with Brothers
        {
          'id': 'joseph_reunion',
          'title': 'Reunion with Brothers',
          'difficulty': 'Hard',
          'timerEnabled': true,
          'timerDurationSeconds': 25,
          'requiredCorrect': 7,
          'narratives': [
            {
              'text':
                  'When the famine struck the known world, people came to Egypt from every direction to buy grain. Among those who came were ten of Joseph\'s brothers — Jacob had sent them to buy grain in Egypt but kept his youngest son Benjamin home, fearing harm might come to him. Joseph recognized his brothers the moment he saw them, but they did not recognize him. The powerful Egyptian official standing before them in royal robes was their brother they had sold as a slave twenty years before.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Joseph treated his brothers as strangers and spoke harshly to them, accusing them of being spies. He demanded that one of them remain as a hostage while the others returned home and came back with their youngest brother Benjamin to prove their story. Simeon was bound before their eyes and kept behind. As the brothers talked among themselves in their own language — not realizing Joseph understood them — they said to each other, "Surely we are being punished because of what we did to Joseph." Hearing this, Joseph turned away from them and wept.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Eventually, driven by hunger, the brothers returned to Egypt with Benjamin. Joseph could barely contain himself when he saw his younger brother. He rushed into a private room and wept. When he had composed himself he returned and they ate together. Then Joseph instructed his steward to hide his silver divining cup in Benjamin\'s sack. When the brothers were stopped and the cup was found, they were brought back to face Joseph. Judah stepped forward and offered himself in Benjamin\'s place, unwilling to see his father bear another loss.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Joseph could hold back no longer. He cleared the room of all his Egyptian attendants and, with great weeping that could be heard throughout the palace, revealed himself to his brothers: "I am Joseph! Is my father still living?" The brothers were too terrified to speak. But Joseph reassured them: "Do not be distressed or angry with yourselves for selling me here, because it was to save lives that God sent me ahead of you." Jacob\'s entire family — seventy people in all — came down to Egypt and settled in the region of Goshen.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Why did the brothers travel to Egypt during the famine?',
              'options': [
                'To seek Joseph whom they had sold',
                'To buy grain during the famine',
                'To escape from enemies in Canaan',
                'To pay tribute to the Pharaoh',
              ],
              'answer': 'To buy grain during the famine',
              'explanation':
                  'When Jacob learned that there was grain in Egypt, he sent ten of his sons there to buy grain during the severe famine.',
              'bibleReference': 'Genesis 42:1-3',
            },
            {
              'question': 'Which brother did Joseph keep as a hostage on the brothers\' first visit?',
              'options': [
                'Reuben',
                'Levi',
                'Simeon',
                'Dan',
              ],
              'answer': 'Simeon',
              'explanation':
                  'Joseph had Simeon taken from the brothers and bound before their eyes, to be kept in Egypt while the rest returned home to bring back Benjamin.',
              'bibleReference': 'Genesis 42:24',
            },
            {
              'question': 'What did Joseph demand the brothers bring with them on their next visit?',
              'options': [
                'A gift of gold and silver',
                'Their father Jacob himself',
                'Their youngest brother Benjamin',
                'A signed letter from their tribe leader',
              ],
              'answer': 'Their youngest brother Benjamin',
              'explanation':
                  'Joseph insisted that the brothers could not see his face again unless their youngest brother Benjamin came with them to Egypt.',
              'bibleReference': 'Genesis 43:3',
            },
            {
              'question': 'What was secretly placed in Benjamin\'s sack to frame him?',
              'options': [
                'Stolen Egyptian coins',
                'A royal document',
                'Joseph\'s silver divining cup',
                'A piece of Pharaoh\'s jewelry',
              ],
              'answer': 'Joseph\'s silver divining cup',
              'explanation':
                  'Joseph instructed his steward to put his silver divining cup in the mouth of Benjamin\'s sack as a test of his brothers\' character.',
              'bibleReference': 'Genesis 44:2',
            },
            {
              'question': 'Which brother stepped forward and offered to take Benjamin\'s place in slavery?',
              'options': [
                'Reuben',
                'Judah',
                'Zebulun',
                'Naphtali',
              ],
              'answer': 'Judah',
              'explanation':
                  'Judah came forward and pleaded passionately for Benjamin\'s release, offering himself as a slave in Benjamin\'s place so that his father would not die of grief.',
              'bibleReference': 'Genesis 44:33',
            },
            {
              'question': 'What did Joseph say when he finally revealed himself to his brothers?',
              'options': [
                '"You are forgiven — go and sin no more!"',
                '"I am Joseph! Is my father still living?"',
                '"God has told me who you are — bow before me!"',
                '"I have been waiting for this day of judgment!"',
              ],
              'answer': '"I am Joseph! Is my father still living?"',
              'explanation':
                  'Unable to control himself any longer, Joseph wept aloud and declared, "I am Joseph! Is my father still living?" — the brothers were too terrified to answer.',
              'bibleReference': 'Genesis 45:3',
            },
            {
              'question': 'In which region of Egypt did Jacob\'s family settle?',
              'options': [
                'The Nile Delta',
                'The Valley of the Kings',
                'Goshen',
                'Memphis',
              ],
              'answer': 'Goshen',
              'explanation':
                  'Joseph instructed his brothers to bring Jacob and their families to Egypt and settle in the region of Goshen, the best part of the land.',
              'bibleReference': 'Genesis 45:10',
            },
            {
              'question': 'How many members of Jacob\'s family came to settle in Egypt?',
              'options': [
                '40',
                '50',
                '60',
                '70',
              ],
              'answer': '70',
              'explanation':
                  'All those who went to Egypt with Jacob — those who were his direct descendants, not counting his sons\' wives — numbered seventy in all.',
              'bibleReference': 'Genesis 46:27',
            },
            {
              'question': 'What did Joseph say to comfort his brothers about what they had done to him?',
              'options': [
                '"You are guilty but I will have mercy on you this once"',
                '"You meant evil against me, but God meant it for good"',
                '"Your punishment will come from God, not from me"',
                '"What is done is done and cannot be changed"',
              ],
              'answer': '"You meant evil against me, but God meant it for good"',
              'explanation':
                  'After Jacob\'s death, when the brothers feared Joseph\'s revenge, he reassured them: "You intended to harm me, but God intended it for good to accomplish what is now being done, the saving of many lives."',
              'bibleReference': 'Genesis 50:20',
            },
            {
              'question': 'How old was Jacob when he went down to Egypt to be reunited with Joseph?',
              'options': [
                '110',
                '120',
                '125',
                '130',
              ],
              'answer': '130',
              'explanation':
                  'When Pharaoh asked Jacob his age, Jacob replied, "The years of my pilgrimage are a hundred and thirty."',
              'bibleReference': 'Genesis 47:9',
            },
          ],
        },
      ],
    },
    {
      'id': 'elijah_and_elisha',
      'title': 'Elijah and Elisha',
      'description': 'Witness the mighty works of two of Israel\'s greatest prophets — from fire falling on Mount Carmel to chariots of fire in the sky.',
      'chapters': [
        {
          'id': 'prophets_of_baal',
          'title': 'Elijah vs the Prophets of Baal',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text': 'During the reign of King Ahab, Israel had turned away from God and began worshipping Baal. Ahab, influenced by his wife Jezebel, built altars to Baal and led the nation into deep idolatry. God\'s prophet Elijah stood alone against this tide of wickedness, declaring a drought on the land until further notice.',
              'speaker': 'Narrator',
            },
            {
              'text': 'After three years of drought, Elijah issued a bold challenge to King Ahab. He called for all of Israel to assemble on Mount Carmel, along with the 450 prophets of Baal. There, Elijah proposed a contest: each side would prepare a sacrifice, and the God who answered by fire would be declared the true God.',
              'speaker': 'Narrator',
            },
            {
              'text': 'The prophets of Baal cried out all morning, dancing around their altar, cutting themselves with swords and shouting. But no answer came. Elijah mocked them, suggesting perhaps Baal was asleep, traveling, or deep in thought. Then Elijah repaired the altar of the Lord, placed his offering on it, and drenched everything with water three times.',
              'speaker': 'Narrator',
            },
            {
              'text': 'When Elijah prayed a simple, sincere prayer to the God of Abraham, Isaac, and Israel, fire fell from heaven and consumed the sacrifice, the wood, the stones, the soil, and even licked up the water. The people fell on their faces and cried out in worship. The contest was over — God had answered definitively.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Who was the wicked king of Israel during Elijah\'s time?',
              'options': ['Jeroboam', 'Ahab', 'Saul', 'Rehoboam'],
              'answer': 'Ahab',
              'explanation': 'King Ahab son of Omri did more evil in the sight of the Lord than any before him, including setting up altars for Baal.',
              'bibleReference': '1 Kings 16:30-33',
            },
            {
              'question': 'Who was King Ahab\'s wicked wife who promoted Baal worship in Israel?',
              'options': ['Delilah', 'Athaliah', 'Jezebel', 'Herodias'],
              'answer': 'Jezebel',
              'explanation': 'Jezebel was a Phoenician princess who married Ahab and actively promoted the worship of Baal, even killing the Lord\'s prophets.',
              'bibleReference': '1 Kings 18:4',
            },
            {
              'question': 'On which mountain did Elijah challenge the prophets of Baal?',
              'options': ['Mount Sinai', 'Mount Zion', 'Mount Horeb', 'Mount Carmel'],
              'answer': 'Mount Carmel',
              'explanation': 'Elijah summoned all Israel and the 450 prophets of Baal to Mount Carmel for the great contest.',
              'bibleReference': '1 Kings 18:19',
            },
            {
              'question': 'How many prophets of Baal gathered on Mount Carmel?',
              'options': ['250', '400', '450', '500'],
              'answer': '450',
              'explanation': 'There were 450 prophets of Baal gathered on Mount Carmel, along with 400 prophets of Asherah.',
              'bibleReference': '1 Kings 18:19',
            },
            {
              'question': 'What did Elijah challenge the prophets of Baal to do?',
              'options': ['Predict the weather', 'Call fire from heaven to burn a sacrifice', 'Part the Jordan River', 'Make it rain'],
              'answer': 'Call fire from heaven to burn a sacrifice',
              'explanation': 'Elijah proposed that each side prepare a bull on wood but light no fire — the God who answered by fire would be declared the true God.',
              'bibleReference': '1 Kings 18:23-24',
            },
            {
              'question': 'What did the prophets of Baal do all day trying to get their god to respond?',
              'options': ['Prayed silently', 'Fasted and wept', 'Danced, shouted, and cut themselves', 'Built a bigger altar'],
              'answer': 'Danced, shouted, and cut themselves',
              'explanation': 'The prophets of Baal danced around the altar, shouted, and slashed themselves with swords and spears from morning until evening, but no answer came.',
              'bibleReference': '1 Kings 18:26-28',
            },
            {
              'question': 'What did Elijah mock, suggesting about Baal when there was no answer?',
              'options': ['That Baal never existed', 'That Baal was sleeping or traveling', 'That Baal had gone to another country forever', 'That Baal was angry at his prophets'],
              'answer': 'That Baal was sleeping or traveling',
              'explanation': 'Elijah taunted them saying perhaps Baal was deep in thought, busy, traveling, or sleeping and needed to be wakened.',
              'bibleReference': '1 Kings 18:27',
            },
            {
              'question': 'What did Elijah pour over his altar and sacrifice before praying?',
              'options': ['Oil', 'Wine', 'Water', 'Salt'],
              'answer': 'Water',
              'explanation': 'Elijah had water poured over the sacrifice and the wood three times, filling even the trench around the altar, making the miracle of fire all the more dramatic.',
              'bibleReference': '1 Kings 18:33-35',
            },
            {
              'question': 'What happened when Elijah prayed to God on Mount Carmel?',
              'options': ['Rain fell heavily', 'An earthquake shook the mountain', 'Fire fell from heaven and consumed the sacrifice', 'A loud voice spoke from the sky'],
              'answer': 'Fire fell from heaven and consumed the sacrifice',
              'explanation': 'The fire of the Lord fell and consumed the burnt offering, the wood, the stones, the soil, and licked up all the water in the trench.',
              'bibleReference': '1 Kings 18:38',
            },
            {
              'question': 'What did the people cry out when they saw God\'s fire fall on Mount Carmel?',
              'options': ['Elijah is the greatest prophet!', 'The Lord, He is God!', 'Baal has been defeated!', 'Let us sacrifice to Elijah!'],
              'answer': 'The Lord, He is God!',
              'explanation': 'When all the people saw God\'s fire, they fell prostrate and cried out, "The Lord — He is God! The Lord — He is God!"',
              'bibleReference': '1 Kings 18:39',
            },
          ],
        },
        {
          'id': 'still_small_voice',
          'title': 'The Still Small Voice',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text': 'Despite his great victory on Mount Carmel, Elijah\'s courage quickly fled when Queen Jezebel sent a message threatening to kill him within a day. Overcome with fear, Elijah ran into the wilderness of Judah, leaving his servant behind. He sat under a broom tree, exhausted and defeated in spirit.',
              'speaker': 'Narrator',
            },
            {
              'text': 'Under the broom tree, Elijah prayed that he might die, saying he was no better than his ancestors. But God was not done with him. An angel touched him and provided freshly baked bread and a jar of water. Twice the angel came, telling him to eat, for the journey ahead was too great for him.',
              'speaker': 'Narrator',
            },
            {
              'text': 'Strengthened by that heavenly food, Elijah traveled forty days and forty nights until he reached Horeb, the mountain of God. He took shelter in a cave. God asked him, "What are you doing here, Elijah?" Elijah poured out his heart — he felt utterly alone, as though he were the last faithful person in all of Israel.',
              'speaker': 'Narrator',
            },
            {
              'text': 'God told Elijah to stand on the mountain. A great wind tore the mountains apart, then an earthquake shook the ground, then fire blazed — but God was not in any of these dramatic displays. After the fire came a still small voice, a gentle whisper. It was in that quiet moment that God spoke to Elijah with new purpose and a new assignment.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Who threatened to kill Elijah after the defeat of Baal\'s prophets?',
              'options': ['King Ahab', 'Jezebel', 'The army of Israel', 'The people of Samaria'],
              'answer': 'Jezebel',
              'explanation': 'Jezebel sent a messenger to Elijah swearing she would take his life within a day, just as he had killed her prophets.',
              'bibleReference': '1 Kings 19:2',
            },
            {
              'question': 'Where did Elijah flee to after Jezebel\'s threat?',
              'options': ['Egypt', 'The wilderness near Beersheba', 'Nineveh', 'The Jordan River'],
              'answer': 'The wilderness near Beersheba',
              'explanation': 'Elijah ran for his life to Beersheba in Judah, left his servant there, and went a day\'s journey into the wilderness.',
              'bibleReference': '1 Kings 19:3-4',
            },
            {
              'question': 'What did Elijah ask God for while sitting under the broom tree?',
              'options': ['To be taken to heaven immediately', 'Strength to fight Jezebel', 'To die', 'A new mission'],
              'answer': 'To die',
              'explanation': 'In despair, Elijah prayed, "I have had enough, Lord. Take my life; I am no better than my ancestors."',
              'bibleReference': '1 Kings 19:4',
            },
            {
              'question': 'Who brought Elijah food and water in the wilderness?',
              'options': ['A fellow prophet', 'King Ahab\'s servant', 'An angel', 'Elisha'],
              'answer': 'An angel',
              'explanation': 'An angel of the Lord touched Elijah twice, providing freshly baked bread over hot coals and a jar of water.',
              'bibleReference': '1 Kings 19:5-7',
            },
            {
              'question': 'How many days and nights did Elijah travel to reach Horeb?',
              'options': ['7 days and nights', '14 days and nights', '30 days and nights', '40 days and nights'],
              'answer': '40 days and nights',
              'explanation': 'Strengthened by the angelic food, Elijah traveled forty days and forty nights until he reached Horeb, the mountain of God.',
              'bibleReference': '1 Kings 19:8',
            },
            {
              'question': 'Where did Elijah shelter when he arrived at Mount Horeb?',
              'options': ['Under a tree', 'In a cave', 'In a tent', 'By a river'],
              'answer': 'In a cave',
              'explanation': 'Elijah arrived at Horeb and spent the night in a cave, where God came to him and asked what he was doing there.',
              'bibleReference': '1 Kings 19:9',
            },
            {
              'question': 'What natural phenomena occurred on the mountain before God spoke — but God was NOT in them?',
              'options': ['Rain, thunder, and flood', 'Wind, earthquake, and fire', 'Hail, lightning, and fog', 'Drought, famine, and darkness'],
              'answer': 'Wind, earthquake, and fire',
              'explanation': 'A great wind, an earthquake, and a fire all occurred, but the Lord was not in any of them — He spoke after the fire in a gentle whisper.',
              'bibleReference': '1 Kings 19:11-12',
            },
            {
              'question': 'How did God speak to Elijah on Mount Horeb?',
              'options': ['In a thunderous voice', 'Through a vision in the night', 'In a still small voice — a gentle whisper', 'Through a burning bush'],
              'answer': 'In a still small voice — a gentle whisper',
              'explanation': 'After the dramatic wind, earthquake, and fire, God spoke to Elijah in a still small voice, a sound of sheer silence.',
              'bibleReference': '1 Kings 19:12',
            },
            {
              'question': 'How many faithful Israelites did God say had not bowed to Baal?',
              'options': ['1,000', '3,000', '5,000', '7,000'],
              'answer': '7,000',
              'explanation': 'God told Elijah He had reserved 7,000 in Israel who had not bowed the knee to Baal or kissed his image.',
              'bibleReference': '1 Kings 19:18',
            },
            {
              'question': 'What task did God give Elijah next after speaking to him at Horeb?',
              'options': ['Return to Jezreel and confront Ahab', 'Anoint Hazael, Jehu, and Elisha', 'Build an altar at Horeb', 'Prophesy the end of Ahab\'s dynasty'],
              'answer': 'Anoint Hazael, Jehu, and Elisha',
              'explanation': 'God commanded Elijah to go and anoint Hazael as king over Syria, Jehu as king over Israel, and Elisha son of Shaphat as prophet in his place.',
              'bibleReference': '1 Kings 19:15-16',
            },
          ],
        },
        {
          'id': 'chariot_of_fire',
          'title': 'Elijah\'s Chariot of Fire',
          'difficulty': 'Medium',
          'timerEnabled': true,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text': 'The time came for God to take Elijah up into heaven. Elijah and his faithful successor Elisha set out from Gilgal together. Though Elijah urged Elisha three times to stay behind — first at Bethel, then at Jericho, then at the Jordan — Elisha refused to leave his master\'s side, declaring each time, "As the Lord lives and as you live, I will not leave you."',
              'speaker': 'Narrator',
            },
            {
              'text': 'Fifty prophets from Jericho watched from a distance as the two men reached the Jordan River. Elijah took his cloak, rolled it up, and struck the water. The water divided to the right and to the left, and the two crossed over on dry ground — a miracle echoing the great crossing of Moses.',
              'speaker': 'Narrator',
            },
            {
              'text': 'On the other side, Elijah asked Elisha what he could do for him before he was taken away. Elisha boldly asked for a double portion of Elijah\'s spirit. Elijah said that was a difficult thing, but if Elisha saw him being taken, the request would be granted. Then, as they walked and talked, a chariot of fire and horses of fire appeared and separated them.',
              'speaker': 'Narrator',
            },
            {
              'text': 'Elijah went up to heaven in a whirlwind. Elisha saw it and cried out, "My father! My father! The chariots and horsemen of Israel!" When Elijah was gone, Elisha picked up the cloak that had fallen from him. He returned to the Jordan, struck the water with Elijah\'s cloak, and the water parted again — the double portion had been granted.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'What river did Elijah part with his rolled-up cloak?',
              'options': ['The Nile', 'The Euphrates', 'The Jordan', 'The Kishon'],
              'answer': 'The Jordan',
              'explanation': 'Elijah took his cloak, rolled it up and struck the Jordan River, which divided so both men could cross on dry ground.',
              'bibleReference': '2 Kings 2:8',
            },
            {
              'question': 'What did Elisha ask Elijah for before he was taken?',
              'options': ['His staff and sandals', 'A double portion of his spirit', 'Wisdom to lead Israel', 'A long life'],
              'answer': 'A double portion of his spirit',
              'explanation': 'Elisha asked for a double portion of Elijah\'s spirit — the inheritance request of a firstborn son — to carry on the prophetic ministry powerfully.',
              'bibleReference': '2 Kings 2:9',
            },
            {
              'question': 'How was Elijah taken up into heaven?',
              'options': ['On a white cloud', 'By a chariot and horses of fire in a whirlwind', 'Through a pillar of light', 'By a strong wind that lifted him up'],
              'answer': 'By a chariot and horses of fire in a whirlwind',
              'explanation': 'A chariot of fire and horses of fire appeared and separated Elijah and Elisha, and Elijah went up to heaven in a whirlwind.',
              'bibleReference': '2 Kings 2:11',
            },
            {
              'question': 'What did Elisha cry out as Elijah was taken to heaven?',
              'options': ['Lord, do not take him from me!', 'My father! The chariots and horsemen of Israel!', 'God of Elijah, where are You now?', 'Elijah, come back to us!'],
              'answer': 'My father! The chariots and horsemen of Israel!',
              'explanation': 'Elisha tore his own clothes and cried out, "My father! My father! The chariots and horsemen of Israel!" — a title of deep honor for Elijah.',
              'bibleReference': '2 Kings 2:12',
            },
            {
              'question': 'What did Elisha pick up after Elijah was taken?',
              'options': ['Elijah\'s sandals', 'Elijah\'s staff', 'Elijah\'s cloak — his mantle', 'A scroll Elijah left behind'],
              'answer': 'Elijah\'s cloak — his mantle',
              'explanation': 'Elisha picked up the cloak that had fallen from Elijah, which symbolized the transfer of prophetic authority.',
              'bibleReference': '2 Kings 2:13',
            },
            {
              'question': 'What did Elisha do with Elijah\'s cloak at the Jordan River?',
              'options': ['Wore it to Jericho', 'Burned it as an offering', 'Struck the water and it parted', 'Wrapped it around a sick man to heal him'],
              'answer': 'Struck the water and it parted',
              'explanation': 'Elisha struck the Jordan with Elijah\'s cloak and the water divided, confirming he had received the double portion of Elijah\'s spirit.',
              'bibleReference': '2 Kings 2:14',
            },
            {
              'question': 'Who watched from a distance as Elijah and Elisha crossed the Jordan?',
              'options': ['The king\'s soldiers', 'The elders of Israel', '50 prophets from Jericho', 'Elisha\'s family'],
              'answer': '50 prophets from Jericho',
              'explanation': 'Fifty men from the company of the prophets stood at a distance watching as Elijah and Elisha crossed the Jordan River.',
              'bibleReference': '2 Kings 2:7',
            },
            {
              'question': 'How many times did Elijah tell Elisha to stay behind on their final journey?',
              'options': ['Once', 'Twice', 'Three times', 'Four times'],
              'answer': 'Three times',
              'explanation': 'Elijah told Elisha to stay at Gilgal, then at Bethel, then at Jericho — but each time Elisha refused to leave.',
              'bibleReference': '2 Kings 2:2-6',
            },
            {
              'question': 'What confirmed that Elisha had truly received Elijah\'s spirit?',
              'options': ['Fire fell on his altar', 'He spoke in Elijah\'s voice', 'The Jordan parted when he struck it', 'Jezebel feared him immediately'],
              'answer': 'The Jordan parted when he struck it',
              'explanation': 'When the Jordan River divided at Elisha\'s strike with Elijah\'s cloak, the company of prophets recognized that the spirit of Elijah rested on Elisha.',
              'bibleReference': '2 Kings 2:14-15',
            },
            {
              'question': 'Which Old Testament prophet never experienced physical death?',
              'options': ['Enoch', 'Elijah', 'Moses', 'Isaiah'],
              'answer': 'Elijah',
              'explanation': 'Elijah was taken up alive to heaven in a whirlwind, making him one of only two people in the Bible who did not die — the other being Enoch.',
              'bibleReference': '2 Kings 2:11',
            },
          ],
        },
        {
          'id': 'elisha_miracles',
          'title': 'Elisha\'s Miracles',
          'difficulty': 'Hard',
          'timerEnabled': true,
          'timerDurationSeconds': 25,
          'requiredCorrect': 7,
          'narratives': [
            {
              'text': 'Elisha began his ministry with compassion and supernatural power. In Jericho, he healed a spring of bitter, unusable water by throwing salt into it. His ministry demonstrated that God\'s power was not just for dramatic confrontations but for the everyday needs of the people — widows, soldiers, and foreigners alike.',
              'speaker': 'Narrator',
            },
            {
              'text': 'A widow in desperate debt came to Elisha with only a small jar of oil. Elisha told her to borrow as many empty jars as she could, then pour from her single jar. Miraculously the oil kept flowing, filling every jar she had borrowed — enough to sell and pay all her debts and live on the rest.',
              'speaker': 'Narrator',
            },
            {
              'text': 'A wealthy Shunammite woman showed Elisha great hospitality, so God blessed her with a son. Years later the child died suddenly. The woman rode to Elisha in great distress. Elisha came and stretched himself over the dead boy twice; the child sneezed seven times and opened his eyes. God had raised him from the dead.',
              'speaker': 'Narrator',
            },
            {
              'text': 'Naaman, commander of the Syrian army, suffered from leprosy. He came to Elisha seeking healing. Though proud and offended by Elisha\'s simple instructions, Naaman\'s servants persuaded him to obey. He dipped seven times in the Jordan River and his skin became clean like a little child\'s. God\'s grace extended beyond the borders of Israel.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'What did Elisha throw into the spring to heal the bitter, undrinkable waters of Jericho?',
              'options': ['Oil', 'A stone', 'Salt', 'A branch'],
              'answer': 'Salt',
              'explanation': 'Elisha threw salt into the spring and declared the Lord had healed the water — the spring has been wholesome ever since.',
              'bibleReference': '2 Kings 2:20-22',
            },
            {
              'question': 'Who was the foreign military commander healed of leprosy through Elisha?',
              'options': ['Gehazi', 'Hazael', 'Ben-Hadad', 'Naaman'],
              'answer': 'Naaman',
              'explanation': 'Naaman was the commander of the army of the king of Aram who came to Elisha and was healed of his leprosy.',
              'bibleReference': '2 Kings 5:1',
            },
            {
              'question': 'In which river was Naaman told to wash in order to be healed of leprosy?',
              'options': ['The Nile', 'The Euphrates', 'The Abana', 'The Jordan'],
              'answer': 'The Jordan',
              'explanation': 'Elisha instructed Naaman to wash seven times in the Jordan River, and his flesh would be restored.',
              'bibleReference': '2 Kings 5:10',
            },
            {
              'question': 'How many times did Naaman dip in the river to be healed?',
              'options': ['Once', 'Three times', 'Five times', '7 times'],
              'answer': '7 times',
              'explanation': 'Naaman dipped himself seven times in the Jordan, as Elisha had instructed, and his flesh was restored and became clean like a young boy\'s.',
              'bibleReference': '2 Kings 5:14',
            },
            {
              'question': 'What did the widow\'s miraculous oil fill when Elisha performed his miracle?',
              'options': ['The city\'s cisterns', 'All the jars and vessels she could borrow', 'A large clay pot in the temple', 'The jars of her neighbors only'],
              'answer': 'All the jars and vessels she could borrow',
              'explanation': 'Elisha told the widow to borrow as many empty vessels as she could; the oil from her small jar kept flowing until every borrowed vessel was full.',
              'bibleReference': '2 Kings 4:3-6',
            },
            {
              'question': 'Whose son did Elisha raise from the dead?',
              'options': ['The widow of Zarephath\'s son', 'The Shunammite woman\'s son', 'The commander\'s son', 'Elisha\'s servant\'s son'],
              'answer': 'The Shunammite woman\'s son',
              'explanation': 'The Shunammite woman, who had shown great hospitality to Elisha, saw her son die suddenly; Elisha came and raised the boy back to life.',
              'bibleReference': '2 Kings 4:32-35',
            },
            {
              'question': 'What food did Elisha purify when someone cried out "There is death in the pot"?',
              'options': ['Spoiled meat with maggots', 'Contaminated water mixed with grain', 'Poisonous stew made from wild gourds', 'Bread made with bad flour'],
              'answer': 'Poisonous stew made from wild gourds',
              'explanation': 'When a man added wild gourds to a stew during famine making it poisonous, Elisha threw flour into the pot and the stew became harmless.',
              'bibleReference': '2 Kings 4:38-41',
            },
            {
              'question': 'How many men did Elisha feed with only 20 loaves of barley bread?',
              'options': ['50 men', '100 men', '200 men', '500 men'],
              'answer': '100 men',
              'explanation': 'A man brought twenty loaves of barley bread to Elisha; though his servant questioned how it could feed 100 men, they ate and had leftovers.',
              'bibleReference': '2 Kings 4:42-44',
            },
            {
              'question': 'What did Elisha\'s servant see when God opened his eyes during the Syrian siege?',
              'options': ['A great army of angels standing guard', 'Horses and chariots of fire surrounding the hill', 'A shining cloud covering the city', 'Lions and eagles protecting the gates'],
              'answer': 'Horses and chariots of fire surrounding the hill',
              'explanation': 'When the servant was terrified by the Syrian army, Elisha prayed for his eyes to be opened; he then saw the hills full of horses and chariots of fire.',
              'bibleReference': '2 Kings 6:17',
            },
            {
              'question': 'Who was Elisha\'s greedy servant who was cursed with Naaman\'s leprosy?',
              'options': ['Eliezer', 'Jonah', 'Gehazi', 'Micaiah'],
              'answer': 'Gehazi',
              'explanation': 'Gehazi secretly ran after Naaman and accepted gifts in Elisha\'s name. When Elisha confronted him, Gehazi was struck with Naaman\'s leprosy.',
              'bibleReference': '2 Kings 5:20-27',
            },
          ],
        },
      ],
    },
    // =========================================================
    // ARC 6: CREATION AND THE FALL
    // =========================================================
    {
      'id': 'creation_and_fall',
      'title': 'Creation and The Fall',
      'description': 'Journey through the earliest chapters of Scripture — from the dawn of creation to the flood that reset the world. Witness God\'s perfect design, humanity\'s tragic rebellion, the first murder, and the covenant of the rainbow.',
      'chapters': [
        {
          'id': 'in_the_beginning',
          'title': 'In the Beginning',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'Before anything existed — before light, before sound, before time itself — there was God. And in the boundless darkness, He spoke. "Let there be light." And there was light. With each passing day, the formless void was shaped into a masterpiece of unfathomable beauty.', 'speaker': 'Narrator'},
            {'text': 'The skies stretched out above the waters. Dry land emerged, clothed in every kind of plant and tree. The sun, moon, and stars were set in their courses. The seas teemed with life and the skies filled with birds. Every creature upon the earth was spoken into being by the voice of God.', 'speaker': 'Narrator'},
            {'text': 'Then came the crowning act of creation. From the dust of the ground, God formed man and breathed into his nostrils the breath of life. He planted a garden in Eden — a paradise of rivers and fruit-bearing trees — and placed the man there to tend it.', 'speaker': 'Narrator'},
            {'text': 'But God saw that it was not good for man to be alone. So He caused Adam to fall into a deep sleep and from his side fashioned a woman. Adam and Eve stood together in the garden, naked and unashamed, walking in perfect fellowship with their Creator.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'What did God create on the first day?',
              'options': ['The sun and moon', 'Light', 'Dry land', 'Animals'],
              'answer': 'Light',
              'explanation': 'On the first day, God said "Let there be light," and He separated the light from the darkness, calling them day and night.',
              'bibleReference': 'Genesis 1:3-5',
            },
            {
              'question': 'What did God create on the second day?',
              'options': ['The stars', 'Fish and birds', 'The sky (firmament)', 'Trees and plants'],
              'answer': 'The sky (firmament)',
              'explanation': 'On the second day, God made the firmament (expanse) to separate the waters above from the waters below, and He called it Heaven.',
              'bibleReference': 'Genesis 1:6-8',
            },
            {
              'question': 'On which day did God create vegetation, plants, and trees?',
              'options': ['Second day', 'Third day', 'Fourth day', 'Fifth day'],
              'answer': 'Third day',
              'explanation': 'On the third day, God gathered the waters to reveal dry land, and then commanded the earth to bring forth grass, herbs, and fruit trees.',
              'bibleReference': 'Genesis 1:9-13',
            },
            {
              'question': 'What was created on the fourth day?',
              'options': ['Birds and fish', 'Sun, moon, and stars', 'Land animals', 'Man and woman'],
              'answer': 'Sun, moon, and stars',
              'explanation': 'On the fourth day, God made the sun to rule the day, the moon to rule the night, and the stars, setting them in the firmament of heaven.',
              'bibleReference': 'Genesis 1:14-19',
            },
            {
              'question': 'What did God create on the fifth day?',
              'options': ['Land animals and livestock', 'Sea creatures and birds', 'Trees and plants', 'Man in His image'],
              'answer': 'Sea creatures and birds',
              'explanation': 'On the fifth day, God created great sea creatures and every living thing that moves in the waters, along with every winged bird.',
              'bibleReference': 'Genesis 1:20-23',
            },
            {
              'question': 'What did God do on the seventh day?',
              'options': ['Created the animals', 'Rested from all His work', 'Planted the garden of Eden', 'Created Eve'],
              'answer': 'Rested from all His work',
              'explanation': 'On the seventh day, God ended His work and rested. He blessed the seventh day and sanctified it.',
              'bibleReference': 'Genesis 2:2-3',
            },
            {
              'question': 'From what did God form the first man?',
              'options': ['Water', 'Stone', 'Dust of the ground', 'A word of command'],
              'answer': 'Dust of the ground',
              'explanation': 'The Lord God formed man of the dust of the ground and breathed into his nostrils the breath of life, and man became a living soul.',
              'bibleReference': 'Genesis 2:7',
            },
            {
              'question': 'What was the name of the garden where God placed Adam?',
              'options': ['Gethsemane', 'Eden', 'Canaan', 'Bethel'],
              'answer': 'Eden',
              'explanation': 'God planted a garden eastward in Eden and placed the man He had formed there to tend and keep it.',
              'bibleReference': 'Genesis 2:8',
            },
            {
              'question': 'Which tree were Adam and Eve forbidden to eat from?',
              'options': ['The tree of life', 'The tree of knowledge of good and evil', 'The fig tree', 'The olive tree'],
              'answer': 'The tree of knowledge of good and evil',
              'explanation': 'God commanded Adam not to eat from the tree of the knowledge of good and evil, warning that he would surely die if he did.',
              'bibleReference': 'Genesis 2:16-17',
            },
            {
              'question': 'How did God create Eve?',
              'options': ['From the dust of the ground', 'From Adam\'s rib', 'From the waters', 'By speaking her into existence'],
              'answer': 'From Adam\'s rib',
              'explanation': 'God caused Adam to fall into a deep sleep, took one of his ribs, and from it fashioned a woman and brought her to Adam.',
              'bibleReference': 'Genesis 2:21-22',
            },
          ],
        },
        {
          'id': 'the_fall_of_man',
          'title': 'The Fall of Man',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'In the garden of Eden, all was perfect — every need provided, every joy abundant. But among the creatures God had made, the serpent was the most cunning. It slithered toward Eve with a question designed to plant the seed of doubt: "Did God really say you must not eat from any tree in the garden?"', 'speaker': 'Narrator'},
            {'text': 'Eve corrected the serpent, explaining they could eat from every tree except one — the tree in the middle of the garden. But the serpent twisted the truth: "You will not surely die. God knows that when you eat of it, your eyes will be opened and you will be like God." The fruit looked delightful, and the promise of wisdom was too tempting to resist.', 'speaker': 'Narrator'},
            {'text': 'She took the fruit and ate. She gave some to Adam, who was with her, and he ate as well. In that instant, innocence shattered. Their eyes were opened, and for the first time they felt shame. They sewed fig leaves together to cover themselves and hid among the trees when they heard God walking in the garden.', 'speaker': 'Narrator'},
            {'text': 'God called out, "Where are you?" — not because He did not know, but because He wanted them to confess. Instead, Adam blamed Eve, and Eve blamed the serpent. The consequences were swift and severe: pain, toil, and death entered the world. God clothed them in garments of skin and drove them from Eden, posting cherubim and a flaming sword to guard the way to the tree of life.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'Which creature tempted Eve to eat the forbidden fruit?',
              'options': ['A lion', 'A serpent', 'An eagle', 'A raven'],
              'answer': 'A serpent',
              'explanation': 'The Bible says the serpent was more cunning than any beast of the field that the Lord God had made, and it deceived Eve.',
              'bibleReference': 'Genesis 3:1',
            },
            {
              'question': 'What lie did the serpent tell Eve?',
              'options': ['God does not exist', 'You will not surely die', 'The fruit is poisonous', 'Adam has already eaten'],
              'answer': 'You will not surely die',
              'explanation': 'The serpent directly contradicted God\'s warning by telling Eve, "You will not surely die," and claimed the fruit would make them like God.',
              'bibleReference': 'Genesis 3:4',
            },
            {
              'question': 'What did Adam and Eve do immediately after eating the forbidden fruit?',
              'options': ['They ran from the garden', 'They realized they were naked and sewed fig leaves together', 'They prayed for forgiveness', 'They blamed the serpent'],
              'answer': 'They realized they were naked and sewed fig leaves together',
              'explanation': 'After eating the fruit, their eyes were opened and they knew they were naked, so they sewed fig leaves together to make coverings.',
              'bibleReference': 'Genesis 3:7',
            },
            {
              'question': 'What did Adam and Eve do when they heard God walking in the garden?',
              'options': ['They confessed their sin', 'They hid among the trees', 'They offered a sacrifice', 'They ate more fruit'],
              'answer': 'They hid among the trees',
              'explanation': 'Adam and Eve heard the sound of the Lord God walking in the garden in the cool of the day, and they hid themselves among the trees.',
              'bibleReference': 'Genesis 3:8',
            },
            {
              'question': 'Who did Adam blame when God confronted him?',
              'options': ['The serpent', 'Himself', 'The woman God gave him', 'No one'],
              'answer': 'The woman God gave him',
              'explanation': 'Adam said, "The woman whom You gave to be with me, she gave me of the tree, and I ate," blaming both Eve and indirectly God Himself.',
              'bibleReference': 'Genesis 3:12',
            },
            {
              'question': 'What curse did God place on the serpent?',
              'options': ['It would lose its voice', 'It would crawl on its belly and eat dust', 'It would be cast into fire', 'It would become invisible'],
              'answer': 'It would crawl on its belly and eat dust',
              'explanation': 'God cursed the serpent above all livestock and beasts: "On your belly you shall go, and dust you shall eat all the days of your life."',
              'bibleReference': 'Genesis 3:14',
            },
            {
              'question': 'What consequence of the fall was specifically given to Eve?',
              'options': ['She would never have children', 'Greatly multiplied pain in childbearing', 'She would become mortal immediately', 'She would lose her sight'],
              'answer': 'Greatly multiplied pain in childbearing',
              'explanation': 'God told Eve, "I will greatly multiply your sorrow and your conception; in pain you shall bring forth children."',
              'bibleReference': 'Genesis 3:16',
            },
            {
              'question': 'What did God use to make garments for Adam and Eve?',
              'options': ['Fig leaves', 'Animal skins', 'Wool', 'Linen'],
              'answer': 'Animal skins',
              'explanation': 'The Lord God made tunics of skin for Adam and Eve and clothed them, which was the first shedding of blood as a covering for sin.',
              'bibleReference': 'Genesis 3:21',
            },
            {
              'question': 'What did God place at the east of the garden of Eden to guard the way to the tree of life?',
              'options': ['A wall of fire', 'An angel with a key', 'Cherubim and a flaming sword', 'A great river'],
              'answer': 'Cherubim and a flaming sword',
              'explanation': 'God placed cherubim at the east of the garden of Eden, and a flaming sword which turned every way, to guard the way to the tree of life.',
              'bibleReference': 'Genesis 3:24',
            },
            {
              'question': 'What was the ground cursed to produce because of Adam\'s sin?',
              'options': ['Thorns and thistles', 'Weeds and poison', 'Only bitter fruit', 'Nothing at all'],
              'answer': 'Thorns and thistles',
              'explanation': 'God told Adam, "Cursed is the ground for your sake... both thorns and thistles it shall bring forth for you."',
              'bibleReference': 'Genesis 3:17-18',
            },
          ],
        },
        {
          'id': 'cain_and_abel',
          'title': 'Cain and Abel',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'Outside the garden, life was harder but it went on. Eve bore two sons — Cain, the firstborn, and Abel, his younger brother. As they grew, each found his own path: Cain worked the soil as a farmer, while Abel tended flocks as a shepherd. In time, both brothers brought offerings to the Lord.', 'speaker': 'Narrator'},
            {'text': 'Abel brought the firstborn of his flock and their fat portions — the very best he had. Cain brought an offering of the fruit of the ground. The Lord looked with favor on Abel and his offering, but He did not regard Cain\'s. Anger twisted Cain\'s face, and jealousy took root in his heart.', 'speaker': 'Narrator'},
            {'text': 'God warned Cain: "Why are you angry? If you do well, will you not be accepted? But if you do not, sin is crouching at the door. Its desire is for you, but you must rule over it." Cain ignored the warning. He lured his brother into the field and rose up against Abel and killed him — the first murder in human history.', 'speaker': 'Narrator'},
            {'text': 'When God asked, "Where is Abel your brother?" Cain replied with cold defiance: "Am I my brother\'s keeper?" But Abel\'s blood cried out from the ground. God cursed Cain to be a restless wanderer, and the ground would no longer yield its strength for him. Yet even in judgment, God showed mercy — He placed a mark on Cain so that no one who found him would kill him.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'What was Cain\'s occupation?',
              'options': ['Shepherd', 'Farmer', 'Hunter', 'Carpenter'],
              'answer': 'Farmer',
              'explanation': 'Cain was a tiller of the ground — he worked the soil and brought an offering of its produce to the Lord.',
              'bibleReference': 'Genesis 4:2',
            },
            {
              'question': 'What was Abel\'s occupation?',
              'options': ['Farmer', 'Builder', 'Keeper of sheep', 'Fisherman'],
              'answer': 'Keeper of sheep',
              'explanation': 'Abel was a keeper of sheep. He tended flocks and brought an offering from the firstborn of his flock.',
              'bibleReference': 'Genesis 4:2',
            },
            {
              'question': 'What offering did Abel bring to the Lord?',
              'options': ['Fruit of the ground', 'Firstborn of his flock', 'Gold and silver', 'Grain and wine'],
              'answer': 'Firstborn of his flock',
              'explanation': 'Abel brought of the firstborn of his flock and of their fat. The Lord respected Abel and his offering.',
              'bibleReference': 'Genesis 4:4',
            },
            {
              'question': 'Why was Cain angry?',
              'options': ['Abel stole from him', 'God accepted Abel\'s offering but not his', 'He lost his crops to drought', 'Adam favored Abel over him'],
              'answer': 'God accepted Abel\'s offering but not his',
              'explanation': 'The Lord respected Abel\'s offering but did not respect Cain\'s, which made Cain very angry and his face fell.',
              'bibleReference': 'Genesis 4:4-5',
            },
            {
              'question': 'What did God say was "crouching at the door" for Cain?',
              'options': ['A wild beast', 'Sin', 'Death', 'An angel'],
              'answer': 'Sin',
              'explanation': 'God warned Cain that if he did not do well, sin was crouching at the door, and its desire was for him, but he must rule over it.',
              'bibleReference': 'Genesis 4:7',
            },
            {
              'question': 'What did Cain say when God asked where Abel was?',
              'options': ['He is in the field', 'I do not know — am I my brother\'s keeper?', 'A wild animal took him', 'He went to another land'],
              'answer': 'I do not know — am I my brother\'s keeper?',
              'explanation': 'Cain lied to God and responded with the now-famous deflection, "I do not know. Am I my brother\'s keeper?"',
              'bibleReference': 'Genesis 4:9',
            },
            {
              'question': 'What did God say Abel\'s blood was doing?',
              'options': ['Staining the altar', 'Crying out from the ground', 'Flowing into the river', 'Turning the soil red'],
              'answer': 'Crying out from the ground',
              'explanation': 'God said to Cain, "The voice of your brother\'s blood cries out to Me from the ground."',
              'bibleReference': 'Genesis 4:10',
            },
            {
              'question': 'What was Cain\'s punishment from God?',
              'options': ['Immediate death', 'To be a fugitive and vagabond on the earth', 'To serve Abel\'s children', 'To be cast into darkness'],
              'answer': 'To be a fugitive and vagabond on the earth',
              'explanation': 'God told Cain he would be a fugitive and a vagabond on the earth, and the ground would no longer yield its strength for him.',
              'bibleReference': 'Genesis 4:11-12',
            },
            {
              'question': 'What did God place on Cain to protect him?',
              'options': ['A shield of light', 'A mark', 'An angelic guard', 'A ring of fire'],
              'answer': 'A mark',
              'explanation': 'The Lord set a mark on Cain so that anyone who found him would not kill him, showing mercy even in judgment.',
              'bibleReference': 'Genesis 4:15',
            },
            {
              'question': 'Where did Cain go to live after being sent away?',
              'options': ['The land of Nod', 'The land of Canaan', 'Back to Eden', 'The land of Shinar'],
              'answer': 'The land of Nod',
              'explanation': 'Cain went out from the presence of the Lord and dwelt in the land of Nod, east of Eden.',
              'bibleReference': 'Genesis 4:16',
            },
          ],
        },
        {
          'id': 'noah_and_the_great_flood',
          'title': 'Noah and the Great Flood',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'Generations passed, and humanity multiplied across the earth. But with growth came great wickedness — every inclination of the human heart was evil continually. The violence and corruption grieved God to His very heart. Yet in the midst of a fallen world, one man stood apart: Noah. He was righteous, blameless among his generation, and he walked faithfully with God.', 'speaker': 'Narrator'},
            {'text': 'God revealed His plan to Noah: a great flood would cleanse the earth of its wickedness. But Noah and his family would be spared. God commanded him to build an enormous ark — 300 cubits long, 50 cubits wide, and 30 cubits high — with three decks and rooms throughout, sealed with pitch inside and out.', 'speaker': 'Narrator'},
            {'text': 'Noah obeyed. He loaded the ark with his wife, his three sons — Shem, Ham, and Japheth — and their wives. Animals came two by two, male and female, of every kind. Of the clean animals, seven pairs were taken. Then God shut the door. The fountains of the great deep burst open, the windows of heaven were opened, and rain fell upon the earth for forty days and forty nights.', 'speaker': 'Narrator'},
            {'text': 'The waters rose until every mountain was covered. Every living thing on dry land perished — only Noah and those with him in the ark survived. After 150 days, the waters began to recede. Noah sent out a dove, and when it returned with a fresh olive leaf, he knew the earth was drying. When they finally stepped onto dry ground, Noah built an altar and worshiped the Lord. God set a rainbow in the sky as an everlasting sign of His covenant: never again would a flood destroy all life on earth.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'Why did God decide to send a flood upon the earth?',
              'options': ['To water the crops', 'Because of the wickedness of mankind', 'To test Noah\'s faith', 'To reshape the continents'],
              'answer': 'Because of the wickedness of mankind',
              'explanation': 'God saw that the wickedness of man was great on the earth, and every intent of the thoughts of his heart was only evil continually.',
              'bibleReference': 'Genesis 6:5-7',
            },
            {
              'question': 'How was Noah described in the Bible?',
              'options': ['A mighty warrior', 'A just man, perfect in his generations', 'The wisest man alive', 'A wealthy landowner'],
              'answer': 'A just man, perfect in his generations',
              'explanation': 'Noah was a just man, perfect in his generations. Noah walked with God.',
              'bibleReference': 'Genesis 6:9',
            },
            {
              'question': 'What were the dimensions of the ark in cubits (length x width x height)?',
              'options': ['200 x 40 x 20', '300 x 50 x 30', '450 x 75 x 45', '100 x 25 x 15'],
              'answer': '300 x 50 x 30',
              'explanation': 'God told Noah to make the ark 300 cubits long, 50 cubits wide, and 30 cubits high.',
              'bibleReference': 'Genesis 6:15',
            },
            {
              'question': 'How many decks (stories) did the ark have?',
              'options': ['One', 'Two', 'Three', 'Four'],
              'answer': 'Three',
              'explanation': 'God instructed Noah to make the ark with lower, second, and third decks — three stories in total.',
              'bibleReference': 'Genesis 6:16',
            },
            {
              'question': 'What were the names of Noah\'s three sons?',
              'options': ['Abraham, Isaac, and Jacob', 'Shem, Ham, and Japheth', 'Cain, Abel, and Seth', 'Reuben, Simeon, and Levi'],
              'answer': 'Shem, Ham, and Japheth',
              'explanation': 'Noah had three sons: Shem, Ham, and Japheth, and all three entered the ark with their wives.',
              'bibleReference': 'Genesis 6:10',
            },
            {
              'question': 'How long did it rain during the flood?',
              'options': ['7 days and 7 nights', '40 days and 40 nights', '100 days and 100 nights', '150 days and 150 nights'],
              'answer': '40 days and 40 nights',
              'explanation': 'The rain was upon the earth forty days and forty nights, flooding the entire world.',
              'bibleReference': 'Genesis 7:12',
            },
            {
              'question': 'How many pairs of each clean animal did Noah take on the ark?',
              'options': ['One pair', 'Two pairs', 'Seven pairs', 'Ten pairs'],
              'answer': 'Seven pairs',
              'explanation': 'God told Noah to take seven pairs of every clean animal, male and female, onto the ark.',
              'bibleReference': 'Genesis 7:2',
            },
            {
              'question': 'What bird did Noah first send out from the ark to test for dry land?',
              'options': ['A dove', 'A raven', 'A sparrow', 'An eagle'],
              'answer': 'A raven',
              'explanation': 'Noah first sent out a raven, which went back and forth until the waters had dried up from the earth.',
              'bibleReference': 'Genesis 8:7',
            },
            {
              'question': 'What did the dove bring back to Noah the second time it was sent out?',
              'options': ['A branch of cedar', 'A freshly plucked olive leaf', 'A piece of dry grass', 'Nothing'],
              'answer': 'A freshly plucked olive leaf',
              'explanation': 'The dove came back to Noah in the evening, and in her mouth was a freshly plucked olive leaf, so Noah knew the waters had receded.',
              'bibleReference': 'Genesis 8:11',
            },
            {
              'question': 'What sign did God set in the sky as a covenant that He would never again flood the entire earth?',
              'options': ['A bright star', 'A rainbow', 'A pillar of cloud', 'A ring of fire'],
              'answer': 'A rainbow',
              'explanation': 'God said, "I set My rainbow in the cloud, and it shall be for the sign of the covenant between Me and the earth."',
              'bibleReference': 'Genesis 9:13',
            },
          ],
        },
      ],
    },
    // =========================================================
    // ARC 7: THE LIFE OF ABRAHAM
    // =========================================================
    {
      'id': 'life_of_abraham',
      'title': 'The Life of Abraham',
      'description': 'Journey with Abraham, the father of faith, from his call to leave Ur through God\'s ultimate test on Mount Moriah. Witness how one man\'s obedience shaped the destiny of nations.',
      'chapters': [
        {
          'id': 'call_of_abram',
          'title': 'The Call of Abram',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'In the bustling city of Ur of the Chaldeans, a man named Abram heard the voice of God calling him to leave everything he knew behind. The Lord promised to make him into a great nation and to bless all the families of the earth through him.', 'speaker': 'Narrator'},
            {'text': 'Abram obeyed, taking his wife Sarai and his nephew Lot on a journey of faith into the unknown land of Canaan. Though he did not know what lay ahead, he trusted the One who called him.', 'speaker': 'Narrator'},
            {'text': 'When famine struck the land of Canaan, Abram journeyed to Egypt. There, fear led him to deceive Pharaoh about Sarai, calling her his sister. Yet God protected them and brought them safely back to Canaan.', 'speaker': 'Narrator'},
            {'text': 'As Abram\'s and Lot\'s flocks grew, strife arose between their herdsmen. Abram generously gave Lot the first choice of land, and Lot chose the fertile plains near Sodom, while Abram remained in Canaan where God renewed His promise.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'From what city did God call Abram to leave?',
              'options': ['Ur of the Chaldeans', 'Babylon', 'Nineveh', 'Haran'],
              'answer': 'Ur of the Chaldeans',
              'explanation': 'Abram originally came from Ur of the Chaldeans. His father Terah had first moved the family from Ur to Haran, and from Haran God called Abram onward to Canaan.',
              'bibleReference': 'Genesis 11:31',
            },
            {
              'question': 'Who was Abram\'s wife?',
              'options': ['Sarai', 'Hagar', 'Rebekah', 'Keturah'],
              'answer': 'Sarai',
              'explanation': 'Sarai was Abram\'s wife who accompanied him on the journey from Haran to Canaan. Her name was later changed to Sarah by God.',
              'bibleReference': 'Genesis 11:29',
            },
            {
              'question': 'Which relative traveled with Abram to Canaan?',
              'options': ['His nephew Lot', 'His brother Nahor', 'His cousin Eliezer', 'His father Terah'],
              'answer': 'His nephew Lot',
              'explanation': 'Lot, the son of Abram\'s deceased brother Haran, accompanied Abram and Sarai on their journey to the land of Canaan.',
              'bibleReference': 'Genesis 12:4-5',
            },
            {
              'question': 'What did God promise to make Abram into?',
              'options': ['A great nation', 'A mighty warrior', 'A wealthy merchant', 'A powerful king'],
              'answer': 'A great nation',
              'explanation': 'God promised Abram, "I will make you into a great nation, and I will bless you; I will make your name great, and you will be a blessing."',
              'bibleReference': 'Genesis 12:2',
            },
            {
              'question': 'Why did Abram go down to Egypt?',
              'options': ['There was a famine in the land', 'He was fleeing from enemies', 'God told him to go', 'He wanted to trade goods'],
              'answer': 'There was a famine in the land',
              'explanation': 'A severe famine in the land of Canaan drove Abram to travel to Egypt to find food and sustenance for his family and livestock.',
              'bibleReference': 'Genesis 12:10',
            },
            {
              'question': 'What did Abram tell the Egyptians about Sarai?',
              'options': ['That she was his sister', 'That she was his servant', 'That she was a princess', 'That she was his cousin'],
              'answer': 'That she was his sister',
              'explanation': 'Fearing the Egyptians would kill him to take his beautiful wife, Abram asked Sarai to say she was his sister. She was in fact his half-sister, but this was still a deception.',
              'bibleReference': 'Genesis 12:11-13',
            },
            {
              'question': 'Why did Abram and Lot separate?',
              'options': ['Their herdsmen quarreled over grazing land', 'God commanded them to part ways', 'Lot wanted to return to Ur', 'They had a personal disagreement'],
              'answer': 'Their herdsmen quarreled over grazing land',
              'explanation': 'Both Abram and Lot had become so wealthy in livestock that the land could not support them dwelling together, and quarreling broke out between their herdsmen.',
              'bibleReference': 'Genesis 13:5-7',
            },
            {
              'question': 'What region did Lot choose when he separated from Abram?',
              'options': ['The plain of the Jordan', 'The hills of Hebron', 'The desert of Negev', 'The valley of Shechem'],
              'answer': 'The plain of the Jordan',
              'explanation': 'Lot looked out and saw that the whole plain of the Jordan toward Zoar was well-watered like the garden of the Lord, so he chose that region for himself.',
              'bibleReference': 'Genesis 13:10-11',
            },
            {
              'question': 'How old was Abram when he departed from Haran?',
              'options': ['75 years old', '65 years old', '80 years old', '99 years old'],
              'answer': '75 years old',
              'explanation': 'The Bible records that Abram was seventy-five years old when he set out from Haran to journey to the land of Canaan at God\'s command.',
              'bibleReference': 'Genesis 12:4',
            },
            {
              'question': 'Near which city did Lot settle after separating from Abram?',
              'options': ['Sodom', 'Jericho', 'Beersheba', 'Bethel'],
              'answer': 'Sodom',
              'explanation': 'After choosing the plain of the Jordan, Lot pitched his tents near Sodom, even though the men of Sodom were exceedingly wicked sinners against the Lord.',
              'bibleReference': 'Genesis 13:12-13',
            },
          ],
        },
        {
          'id': 'covenant_and_promises',
          'title': 'The Covenant and Promises',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'After Abram\'s victory in rescuing Lot from captivity, the word of the Lord came to him in a vision, saying, "Do not be afraid, Abram. I am your shield, your very great reward." But Abram wondered how God\'s promises could come true when he remained childless.', 'speaker': 'Narrator'},
            {'text': 'God led Abram outside and told him to count the stars, declaring that his descendants would be just as countless. Abram believed the Lord, and it was credited to him as righteousness. Then God made a solemn covenant with Abram, sealing His promise with a sacred ceremony.', 'speaker': 'Narrator'},
            {'text': 'Years passed with no child, and Sarai grew impatient. She gave her Egyptian servant Hagar to Abram, and Hagar bore a son named Ishmael. But this was not the child of promise that God had planned.', 'speaker': 'Narrator'},
            {'text': 'When Abram was ninety-nine years old, God appeared to him again, changing his name to Abraham — father of many nations — and Sarai\'s name to Sarah. God established circumcision as the sign of His everlasting covenant and promised that Sarah herself would bear a son.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'What did God tell Abram to look at when promising him many descendants?',
              'options': ['The stars in the sky', 'The sand on the seashore', 'The dust of the earth', 'The leaves on the trees'],
              'answer': 'The stars in the sky',
              'explanation': 'God brought Abram outside and said, "Look up at the sky and count the stars — if indeed you can count them. So shall your offspring be."',
              'bibleReference': 'Genesis 15:5',
            },
            {
              'question': 'What was credited to Abram as righteousness?',
              'options': ['He believed the Lord', 'He offered a sacrifice', 'He obeyed God\'s commands', 'He gave tithes to Melchizedek'],
              'answer': 'He believed the Lord',
              'explanation': 'Abram believed the Lord when He promised countless descendants, and God credited that faith to him as righteousness.',
              'bibleReference': 'Genesis 15:6',
            },
            {
              'question': 'What animals did God instruct Abram to bring for the covenant ceremony?',
              'options': ['A heifer, a goat, a ram, a dove, and a pigeon', 'Two lambs and a bull', 'Seven rams and seven ewes', 'A bull and two goats'],
              'answer': 'A heifer, a goat, a ram, a dove, and a pigeon',
              'explanation': 'God told Abram to bring a three-year-old heifer, a three-year-old female goat, a three-year-old ram, a turtledove, and a young pigeon for the covenant ceremony.',
              'bibleReference': 'Genesis 15:9',
            },
            {
              'question': 'Who was Hagar?',
              'options': ['Sarai\'s Egyptian servant', 'Abram\'s second wife from Canaan', 'Lot\'s daughter', 'A priestess of Pharaoh'],
              'answer': 'Sarai\'s Egyptian servant',
              'explanation': 'Hagar was an Egyptian maidservant who belonged to Sarai. When Sarai could not conceive, she gave Hagar to Abram to bear a child on her behalf.',
              'bibleReference': 'Genesis 16:1',
            },
            {
              'question': 'What was the name of Hagar\'s son with Abram?',
              'options': ['Ishmael', 'Isaac', 'Esau', 'Midian'],
              'answer': 'Ishmael',
              'explanation': 'The angel of the Lord told Hagar to name her son Ishmael, meaning "God hears," because the Lord had heard her misery.',
              'bibleReference': 'Genesis 16:11',
            },
            {
              'question': 'What does the name Abraham mean?',
              'options': ['Father of many nations', 'Exalted father', 'God is mighty', 'Beloved of God'],
              'answer': 'Father of many nations',
              'explanation': 'God changed Abram\'s name (meaning "exalted father") to Abraham (meaning "father of many nations") as part of the covenant promise.',
              'bibleReference': 'Genesis 17:5',
            },
            {
              'question': 'What was the sign of the covenant God made with Abraham?',
              'options': ['Circumcision', 'A rainbow', 'An altar of stones', 'A burnt offering'],
              'answer': 'Circumcision',
              'explanation': 'God established circumcision as the sign of the everlasting covenant between Himself and Abraham and all his descendants.',
              'bibleReference': 'Genesis 17:10-11',
            },
            {
              'question': 'What was Sarai\'s name changed to?',
              'options': ['Sarah', 'Hannah', 'Miriam', 'Ruth'],
              'answer': 'Sarah',
              'explanation': 'God said to Abraham, "As for Sarai your wife, you are no longer to call her Sarai; her name will be Sarah," meaning princess.',
              'bibleReference': 'Genesis 17:15',
            },
            {
              'question': 'How old was Abram when Ishmael was born?',
              'options': ['86 years old', '75 years old', '99 years old', '100 years old'],
              'answer': '86 years old',
              'explanation': 'The Bible records that Abram was eighty-six years old when Hagar bore him Ishmael.',
              'bibleReference': 'Genesis 16:16',
            },
            {
              'question': 'How old was Abraham when he was circumcised?',
              'options': ['99 years old', '86 years old', '100 years old', '75 years old'],
              'answer': '99 years old',
              'explanation': 'Abraham was ninety-nine years old when he was circumcised in the flesh of his foreskin, on the very day God commanded it.',
              'bibleReference': 'Genesis 17:24',
            },
          ],
        },
        {
          'id': 'sodom_and_gomorrah',
          'title': 'Sodom and Gomorrah',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'Three visitors appeared at Abraham\'s tent by the oaks of Mamre. Abraham rushed to offer them hospitality, preparing a lavish meal. These were no ordinary travelers — the Lord Himself and two angels had come with a stunning announcement: Sarah would have a son within a year.', 'speaker': 'Narrator'},
            {'text': 'Sarah, listening from the tent entrance, laughed in disbelief at the thought of bearing a child in her old age. But the Lord asked, "Is anything too hard for the Lord?" His promise would not be denied.', 'speaker': 'Narrator'},
            {'text': 'As the visitors turned toward Sodom, the Lord revealed to Abraham His plan to judge the wicked cities. Abraham boldly interceded, bargaining with God to spare the city if even ten righteous people could be found there.', 'speaker': 'Narrator'},
            {'text': 'Two angels entered Sodom and found Lot at the gate. After witnessing the city\'s depravity firsthand, they urged Lot and his family to flee without looking back. Fire and brimstone rained down from heaven, destroying Sodom and Gomorrah completely. But Lot\'s wife looked back and became a pillar of salt.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'How many visitors came to Abraham at the oaks of Mamre?',
              'options': ['Three', 'Two', 'Four', 'One'],
              'answer': 'Three',
              'explanation': 'Abraham looked up and saw three men standing nearby. He hurried to meet them and bowed before them, offering them rest and food.',
              'bibleReference': 'Genesis 18:2',
            },
            {
              'question': 'What did Sarah do when she heard she would have a son?',
              'options': ['She laughed', 'She wept', 'She prayed', 'She fainted'],
              'answer': 'She laughed',
              'explanation': 'Sarah laughed to herself, thinking, "After I am worn out and my lord is old, will I now have this pleasure?" The Lord then asked Abraham why Sarah laughed.',
              'bibleReference': 'Genesis 18:12-13',
            },
            {
              'question': 'What was the lowest number of righteous people Abraham bargained down to in order to spare Sodom?',
              'options': ['Ten', 'Five', 'Twenty', 'One'],
              'answer': 'Ten',
              'explanation': 'Abraham progressively negotiated with God from fifty righteous people down to ten. God agreed He would not destroy Sodom if ten righteous people were found there.',
              'bibleReference': 'Genesis 18:32',
            },
            {
              'question': 'Where was Lot sitting when the two angels arrived in Sodom?',
              'options': ['At the gate of Sodom', 'In his house', 'In the marketplace', 'By the well'],
              'answer': 'At the gate of Sodom',
              'explanation': 'The two angels arrived at Sodom in the evening, and Lot was sitting in the gateway of the city. He bowed down to them and invited them to his home.',
              'bibleReference': 'Genesis 19:1',
            },
            {
              'question': 'What did God rain down on Sodom and Gomorrah?',
              'options': ['Burning sulfur (brimstone) and fire', 'A great flood', 'Hailstones and lightning', 'Darkness and plague'],
              'answer': 'Burning sulfur (brimstone) and fire',
              'explanation': 'The Lord rained down burning sulfur on Sodom and Gomorrah — from the Lord out of the heavens, completely destroying the cities and the entire plain.',
              'bibleReference': 'Genesis 19:24',
            },
            {
              'question': 'What happened to Lot\'s wife when she looked back?',
              'options': ['She became a pillar of salt', 'She was struck by lightning', 'She was consumed by fire', 'She turned to stone'],
              'answer': 'She became a pillar of salt',
              'explanation': 'Despite the angels\' warning not to look back, Lot\'s wife looked behind her and was turned into a pillar of salt.',
              'bibleReference': 'Genesis 19:26',
            },
            {
              'question': 'To which small town did Lot flee before Sodom was destroyed?',
              'options': ['Zoar', 'Bethel', 'Hebron', 'Beersheba'],
              'answer': 'Zoar',
              'explanation': 'Lot pleaded to flee to the nearby small town of Zoar instead of the mountains. The angels granted his request, and the city was spared for his sake.',
              'bibleReference': 'Genesis 19:20-22',
            },
            {
              'question': 'What question did the Lord ask Abraham about Sarah\'s laughter?',
              'options': ['Is anything too hard for the Lord?', 'Why does Sarah doubt My word?', 'Does Sarah not trust in God?', 'Has Sarah forgotten My covenant?'],
              'answer': 'Is anything too hard for the Lord?',
              'explanation': 'When Sarah laughed at the promise of a son, the Lord responded with the rhetorical question, "Is anything too hard for the Lord?"',
              'bibleReference': 'Genesis 18:14',
            },
            {
              'question': 'How did the angels protect Lot from the men of Sodom who surrounded his house?',
              'options': ['They struck the men with blindness', 'They called down fire from heaven', 'They caused an earthquake', 'They sent a strong wind'],
              'answer': 'They struck the men with blindness',
              'explanation': 'The two angels reached out, pulled Lot back inside the house, and struck the men at the door with blindness so they could not find the entrance.',
              'bibleReference': 'Genesis 19:10-11',
            },
          ],
        },
        {
          'id': 'sacrifice_of_isaac',
          'title': 'The Sacrifice of Isaac',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'At last, the impossible promise was fulfilled. Sarah conceived and bore Abraham a son in their old age, at the very time God had promised. Abraham named him Isaac, meaning "he laughs," a joyful reminder of the laughter that had greeted God\'s promise.', 'speaker': 'Narrator'},
            {'text': 'As Isaac grew, tension arose between him and Ishmael. Sarah demanded that Hagar and Ishmael be sent away. Though this grieved Abraham deeply, God assured him that He would also make Ishmael into a great nation.', 'speaker': 'Narrator'},
            {'text': 'Then came the greatest test of Abraham\'s faith. God commanded him to take Isaac — his beloved son of promise — to Mount Moriah and offer him as a burnt offering. With a heavy heart but unwavering obedience, Abraham set out on the three-day journey.', 'speaker': 'Narrator'},
            {'text': 'On the mountain, as Abraham raised the knife, the angel of the Lord called out from heaven, stopping him. Abraham looked up and saw a ram caught in a thicket by its horns. God had provided the sacrifice. Abraham named that place "The Lord Will Provide," and God renewed His covenant blessings upon Abraham and his descendants forever.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'How old was Sarah when Isaac was born?',
              'options': ['90 years old', '80 years old', '75 years old', '100 years old'],
              'answer': '90 years old',
              'explanation': 'Sarah was ninety years old when she bore Isaac. God had promised a son to Abraham when he was ninety-nine and Sarah was eighty-nine, and Isaac was born the following year.',
              'bibleReference': 'Genesis 17:17, 21:1-2',
            },
            {
              'question': 'What does the name Isaac mean?',
              'options': ['He laughs', 'God provides', 'Promised one', 'God hears'],
              'answer': 'He laughs',
              'explanation': 'The name Isaac means "he laughs," reflecting both Abraham\'s and Sarah\'s laughter when God told them they would have a son in their old age.',
              'bibleReference': 'Genesis 17:17, 21:3-6',
            },
            {
              'question': 'Where did God tell Abraham to go to offer Isaac?',
              'options': ['The region of Moriah', 'Mount Sinai', 'The plain of Mamre', 'Beersheba'],
              'answer': 'The region of Moriah',
              'explanation': 'God said, "Take your son, your only son, whom you love — Isaac — and go to the region of Moriah. Sacrifice him there as a burnt offering on a mountain I will show you."',
              'bibleReference': 'Genesis 22:2',
            },
            {
              'question': 'How many days did it take Abraham to reach the place of sacrifice?',
              'options': ['Three days', 'One day', 'Seven days', 'Forty days'],
              'answer': 'Three days',
              'explanation': 'On the third day of their journey, Abraham looked up and saw the place God had told him about in the distance.',
              'bibleReference': 'Genesis 22:4',
            },
            {
              'question': 'What did Isaac ask his father while they were walking to the place of sacrifice?',
              'options': ['Where is the lamb for the burnt offering?', 'Why are we going to this mountain?', 'May I carry the knife?', 'How long will we be gone?'],
              'answer': 'Where is the lamb for the burnt offering?',
              'explanation': 'Isaac noticed they had fire and wood but no animal. He asked, "The fire and wood are here, but where is the lamb for the burnt offering?"',
              'bibleReference': 'Genesis 22:7',
            },
            {
              'question': 'What did Abraham answer when Isaac asked about the lamb?',
              'options': ['God himself will provide the lamb', 'You will see when we arrive', 'The lamb is waiting at the mountain', 'We must trust in God\'s plan'],
              'answer': 'God himself will provide the lamb',
              'explanation': 'Abraham answered, "God himself will provide the lamb for the burnt offering, my son." This was both a statement of faith and a prophecy that was fulfilled.',
              'bibleReference': 'Genesis 22:8',
            },
            {
              'question': 'What animal did God provide as a substitute sacrifice for Isaac?',
              'options': ['A ram caught in a thicket', 'A lamb beside the altar', 'A young goat on the path', 'A dove in the bushes'],
              'answer': 'A ram caught in a thicket',
              'explanation': 'Abraham looked up and saw a ram caught by its horns in a thicket. He sacrificed the ram as a burnt offering instead of his son.',
              'bibleReference': 'Genesis 22:13',
            },
            {
              'question': 'What did Abraham name the place where God provided the ram?',
              'options': ['The Lord Will Provide', 'God Is Faithful', 'The Mountain of Blessing', 'The Altar of Mercy'],
              'answer': 'The Lord Will Provide',
              'explanation': 'Abraham called that place "The Lord Will Provide" (Jehovah-Jireh). It became a saying: "On the mountain of the Lord it will be provided."',
              'bibleReference': 'Genesis 22:14',
            },
            {
              'question': 'Who carried the wood for the burnt offering up the mountain?',
              'options': ['Isaac', 'Abraham', 'A servant', 'A donkey'],
              'answer': 'Isaac',
              'explanation': 'Abraham placed the wood for the burnt offering on his son Isaac, while he himself carried the fire and the knife as the two of them went on together.',
              'bibleReference': 'Genesis 22:6',
            },
            {
              'question': 'How old was Abraham when Isaac was born?',
              'options': ['100 years old', '99 years old', '90 years old', '86 years old'],
              'answer': '100 years old',
              'explanation': 'Abraham was one hundred years old when his son Isaac was born to him, fulfilling God\'s promise at the appointed time.',
              'bibleReference': 'Genesis 21:5',
            },
          ],
        },
      ],
    },
    // =========================================================
    // ARC 8: DANIEL — FAITH IN EXILE
    // =========================================================
    {
      'id': 'daniel_faith_in_exile',
      'title': 'Daniel: Faith in Exile',
      'description':
          'Follow Daniel and his friends as they navigate life in Babylonian captivity, standing firm in their faith through impossible trials — from refusing the king\'s food to surviving a den of lions.',
      'chapters': [
        {
          'id': 'captive_in_babylon',
          'title': 'Captive in Babylon',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'In the third year of King Jehoiakim\'s reign, Nebuchadnezzar king of Babylon besieged Jerusalem. God allowed Judah to fall, and the finest young men of Israel were carried off to serve in a foreign land.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Among the captives were four young men of extraordinary promise — Daniel, Hananiah, Mishael, and Azariah. The Babylonians gave them new names, seeking to strip away their identity and their God.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'But Daniel resolved in his heart that he would not defile himself with the king\'s food or wine. He proposed a test: ten days of vegetables and water. God honored their faithfulness and gave them health, wisdom, and favor.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'At the end of their training, the king found Daniel and his friends ten times better than all the magicians and enchanters in his kingdom. Even in exile, God was with them.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Which king of Babylon besieged Jerusalem and took the captives?',
              'options': ['Nebuchadnezzar', 'Darius', 'Cyrus', 'Belshazzar'],
              'answer': 'Nebuchadnezzar',
              'explanation': 'Nebuchadnezzar king of Babylon came to Jerusalem and besieged it, and the Lord delivered Jehoiakim into his hand.',
              'bibleReference': 'Daniel 1:1-2',
            },
            {
              'question': 'Which king of Judah was reigning when Jerusalem was besieged?',
              'options': ['Jehoiakim', 'Josiah', 'Zedekiah', 'Hezekiah'],
              'answer': 'Jehoiakim',
              'explanation': 'The siege occurred in the third year of the reign of Jehoiakim king of Judah.',
              'bibleReference': 'Daniel 1:1',
            },
            {
              'question': 'What Babylonian name was given to Daniel?',
              'options': ['Belteshazzar', 'Shadrach', 'Meshach', 'Abednego'],
              'answer': 'Belteshazzar',
              'explanation': 'The chief official gave Daniel the name Belteshazzar.',
              'bibleReference': 'Daniel 1:7',
            },
            {
              'question': 'What Babylonian name was given to Hananiah?',
              'options': ['Shadrach', 'Meshach', 'Abednego', 'Belteshazzar'],
              'answer': 'Shadrach',
              'explanation': 'Hananiah was given the Babylonian name Shadrach by the chief official.',
              'bibleReference': 'Daniel 1:7',
            },
            {
              'question': 'What did Daniel resolve not to defile himself with?',
              'options': ['The royal food and wine', 'Babylonian clothing', 'Idol worship', 'The Babylonian language'],
              'answer': 'The royal food and wine',
              'explanation': 'Daniel resolved not to defile himself with the royal food and wine, and he asked the chief official for permission not to defile himself this way.',
              'bibleReference': 'Daniel 1:8',
            },
            {
              'question': 'What did Daniel ask to eat instead of the king\'s food?',
              'options': ['Vegetables and water', 'Bread and milk', 'Fruit and juice', 'Grain and oil'],
              'answer': 'Vegetables and water',
              'explanation': 'Daniel asked to be given nothing but vegetables to eat and water to drink.',
              'bibleReference': 'Daniel 1:12',
            },
            {
              'question': 'How many days did the diet test last?',
              'options': ['Ten days', 'Seven days', 'Thirty days', 'Forty days'],
              'answer': 'Ten days',
              'explanation': 'Daniel proposed a ten-day test, after which they would be compared with the young men who ate the royal food.',
              'bibleReference': 'Daniel 1:12-14',
            },
            {
              'question': 'Who was the official that Daniel made his request to?',
              'options': ['Ashpenaz', 'Arioch', 'Nebuzaradan', 'Rabshakeh'],
              'answer': 'Ashpenaz',
              'explanation': 'The king appointed Ashpenaz, chief of his court officials, to oversee the young men\'s training.',
              'bibleReference': 'Daniel 1:3',
            },
            {
              'question': 'How did Daniel and his friends compare to the other young men after the test?',
              'options': ['They looked healthier and better nourished', 'They looked the same', 'They looked slightly weaker', 'They had grown taller'],
              'answer': 'They looked healthier and better nourished',
              'explanation': 'At the end of ten days they looked healthier and better nourished than any of the young men who ate the royal food.',
              'bibleReference': 'Daniel 1:15',
            },
            {
              'question': 'How much better did the king find Daniel and his friends than the magicians and enchanters?',
              'options': ['Ten times better', 'Five times better', 'Seven times better', 'Three times better'],
              'answer': 'Ten times better',
              'explanation': 'In every matter of wisdom and understanding the king found them ten times better than all the magicians and enchanters in his whole kingdom.',
              'bibleReference': 'Daniel 1:20',
            },
          ],
        },
        {
          'id': 'nebuchadnezzars_dream',
          'title': 'Nebuchadnezzar\'s Dream',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'King Nebuchadnezzar was troubled by a dream that none of his wise men could interpret — for the king demanded they tell him both the dream and its meaning, on pain of death.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'When the decree went out to execute all the wise men of Babylon, Daniel sought the king\'s mercy and asked his friends to plead with God for revelation. That night, the mystery was revealed to Daniel in a vision.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Daniel stood before the king and described a great statue — its head of gold, chest and arms of silver, belly and thighs of bronze, legs of iron, and feet of iron mixed with clay. A stone cut without hands struck the statue and shattered it.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'The king fell prostrate before Daniel, acknowledging that Daniel\'s God was the God of gods. Daniel was elevated to ruler over the province of Babylon, and his three friends were given positions of authority.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'What unusual demand did Nebuchadnezzar make of his wise men?',
              'options': ['Tell him the dream and its interpretation', 'Predict the outcome of a battle', 'Read a mysterious inscription', 'Interpret a sign in the stars'],
              'answer': 'Tell him the dream and its interpretation',
              'explanation': 'The king demanded that the wise men tell him what he had dreamed and then interpret it, or they would be cut into pieces.',
              'bibleReference': 'Daniel 2:5-6',
            },
            {
              'question': 'What was the head of the statue made of?',
              'options': ['Gold', 'Silver', 'Bronze', 'Iron'],
              'answer': 'Gold',
              'explanation': 'The head of the statue was made of pure gold, which Daniel said represented Nebuchadnezzar himself.',
              'bibleReference': 'Daniel 2:32, 38',
            },
            {
              'question': 'What were the chest and arms of the statue made of?',
              'options': ['Silver', 'Gold', 'Bronze', 'Iron'],
              'answer': 'Silver',
              'explanation': 'The chest and arms were made of silver, representing a kingdom that would arise after Nebuchadnezzar\'s.',
              'bibleReference': 'Daniel 2:32, 39',
            },
            {
              'question': 'What were the belly and thighs of the statue made of?',
              'options': ['Bronze', 'Silver', 'Iron', 'Clay'],
              'answer': 'Bronze',
              'explanation': 'The belly and thighs were made of bronze, representing a third kingdom that would rule over the whole earth.',
              'bibleReference': 'Daniel 2:32, 39',
            },
            {
              'question': 'What were the feet of the statue made of?',
              'options': ['Iron mixed with baked clay', 'Pure iron', 'Bronze and silver', 'Gold and clay'],
              'answer': 'Iron mixed with baked clay',
              'explanation': 'The feet were partly of iron and partly of baked clay, representing a divided kingdom.',
              'bibleReference': 'Daniel 2:33, 41',
            },
            {
              'question': 'What struck the statue and destroyed it?',
              'options': ['A rock cut out without human hands', 'A bolt of lightning', 'A great wind', 'A flaming sword'],
              'answer': 'A rock cut out without human hands',
              'explanation': 'A rock was cut out, but not by human hands. It struck the statue on its feet of iron and clay and smashed them.',
              'bibleReference': 'Daniel 2:34-35',
            },
            {
              'question': 'What happened to the pieces of the statue after it was struck?',
              'options': ['They became like chaff blown away by the wind', 'They sank into the earth', 'They turned to water', 'They caught fire and burned'],
              'answer': 'They became like chaff blown away by the wind',
              'explanation': 'The iron, clay, bronze, silver, and gold were all broken to pieces and became like chaff on a threshing floor, and the wind swept them away.',
              'bibleReference': 'Daniel 2:35',
            },
            {
              'question': 'Who was the commander of the king\'s guard that was sent to execute the wise men?',
              'options': ['Arioch', 'Ashpenaz', 'Abednego', 'Azariah'],
              'answer': 'Arioch',
              'explanation': 'Arioch, the commander of the king\'s guard, had gone out to put to death the wise men of Babylon.',
              'bibleReference': 'Daniel 2:14',
            },
            {
              'question': 'What position was Daniel given after interpreting the dream?',
              'options': ['Ruler over the province of Babylon', 'Chief of the royal guard', 'High priest of the temple', 'Commander of the army'],
              'answer': 'Ruler over the province of Babylon',
              'explanation': 'The king placed Daniel in a high position and made him ruler over the entire province of Babylon and chief over all its wise men.',
              'bibleReference': 'Daniel 2:48',
            },
            {
              'question': 'What did Daniel do before going to the king with the interpretation?',
              'options': ['He praised the God of heaven', 'He fasted for three days', 'He consulted the other wise men', 'He made a sacrifice'],
              'answer': 'He praised the God of heaven',
              'explanation': 'After the mystery was revealed to Daniel in a night vision, he praised the God of heaven, acknowledging that wisdom and power belong to God.',
              'bibleReference': 'Daniel 2:19-23',
            },
          ],
        },
        {
          'id': 'the_fiery_furnace',
          'title': 'The Fiery Furnace',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'King Nebuchadnezzar made an image of gold, ninety feet high and nine feet wide, and set it up on the plain of Dura. He commanded every official in the kingdom to bow down and worship it at the sound of music — or be thrown into a blazing furnace.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Shadrach, Meshach, and Abednego refused to bow. When jealous officials reported them to the king, Nebuchadnezzar was furious and gave them one more chance. Their answer was bold: "Our God is able to deliver us, but even if He does not, we will not serve your gods."',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'The king ordered the furnace heated seven times hotter than usual. The three men were bound and thrown in — the flames so intense they killed the soldiers who threw them. But then the king leapt to his feet in amazement.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  '"Were not three men thrown into the fire?" he asked. "I see four men walking around, unbound and unharmed, and the fourth looks like a son of the gods!" God had delivered His faithful servants, and not a hair on their heads was singed.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'How tall was the golden image that Nebuchadnezzar set up?',
              'options': ['Sixty cubits (about 90 feet)', 'Thirty cubits (about 45 feet)', 'Forty cubits (about 60 feet)', 'One hundred cubits (about 150 feet)'],
              'answer': 'Sixty cubits (about 90 feet)',
              'explanation': 'King Nebuchadnezzar made an image of gold, sixty cubits high and six cubits wide.',
              'bibleReference': 'Daniel 3:1',
            },
            {
              'question': 'On what plain was the golden image set up?',
              'options': ['The plain of Dura', 'The plain of Shinar', 'The plain of Megiddo', 'The plain of Jordan'],
              'answer': 'The plain of Dura',
              'explanation': 'The king set up the image on the plain of Dura in the province of Babylon.',
              'bibleReference': 'Daniel 3:1',
            },
            {
              'question': 'What signal told everyone to bow down to the image?',
              'options': ['The sound of musical instruments', 'A trumpet blast', 'The king\'s command', 'The raising of a banner'],
              'answer': 'The sound of musical instruments',
              'explanation': 'When the people heard the sound of the horn, flute, zither, lyre, harp, pipe, and all kinds of music, they were to fall down and worship the golden image.',
              'bibleReference': 'Daniel 3:5',
            },
            {
              'question': 'What was the penalty for not worshipping the golden image?',
              'options': ['Being thrown into a blazing furnace', 'Being put in prison', 'Being exiled from Babylon', 'Being put to death by the sword'],
              'answer': 'Being thrown into a blazing furnace',
              'explanation': 'Whoever did not fall down and worship the image would immediately be thrown into a blazing furnace.',
              'bibleReference': 'Daniel 3:6',
            },
            {
              'question': 'How much hotter did the king order the furnace to be heated?',
              'options': ['Seven times hotter than usual', 'Three times hotter than usual', 'Ten times hotter than usual', 'Twice as hot as usual'],
              'answer': 'Seven times hotter than usual',
              'explanation': 'Nebuchadnezzar was so furious that he ordered the furnace heated seven times hotter than usual.',
              'bibleReference': 'Daniel 3:19',
            },
            {
              'question': 'What happened to the soldiers who threw the three men into the furnace?',
              'options': ['They were killed by the flames', 'They were unharmed', 'They fainted from the heat', 'They fled in fear'],
              'answer': 'They were killed by the flames',
              'explanation': 'The furnace was so hot that the flames of the fire killed the soldiers who threw Shadrach, Meshach, and Abednego into it.',
              'bibleReference': 'Daniel 3:22',
            },
            {
              'question': 'How many figures did the king see walking in the furnace?',
              'options': ['Four', 'Three', 'Five', 'Two'],
              'answer': 'Four',
              'explanation': 'The king said, "Look! I see four men walking around in the fire, unbound and unharmed."',
              'bibleReference': 'Daniel 3:25',
            },
            {
              'question': 'How did the king describe the appearance of the fourth figure in the furnace?',
              'options': ['Like a son of the gods', 'Like an angel of light', 'Like a pillar of fire', 'Like a mighty warrior'],
              'answer': 'Like a son of the gods',
              'explanation': 'Nebuchadnezzar said the fourth figure looked like a son of the gods.',
              'bibleReference': 'Daniel 3:25',
            },
            {
              'question': 'What was the condition of the three men when they came out of the furnace?',
              'options': ['Not a hair was singed and there was no smell of fire', 'Their robes were burned but they were unharmed', 'They had minor burns on their hands', 'They were unconscious but alive'],
              'answer': 'Not a hair was singed and there was no smell of fire',
              'explanation': 'The fire had not harmed their bodies, nor was a hair of their heads singed; their robes were not scorched, and there was no smell of fire on them.',
              'bibleReference': 'Daniel 3:27',
            },
            {
              'question': 'What did Nebuchadnezzar decree after witnessing the miracle?',
              'options': ['No one could speak against the God of Shadrach, Meshach, and Abednego', 'All idols in Babylon must be destroyed', 'Everyone must worship Daniel\'s God', 'The furnace must be torn down'],
              'answer': 'No one could speak against the God of Shadrach, Meshach, and Abednego',
              'explanation': 'The king decreed that anyone who said anything against the God of Shadrach, Meshach, and Abednego would be cut into pieces, because no other god can save in this way.',
              'bibleReference': 'Daniel 3:29',
            },
          ],
        },
        {
          'id': 'the_lions_den',
          'title': 'The Lions\' Den',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {
              'text':
                  'Years passed and kingdoms changed. Under King Darius the Mede, Daniel distinguished himself above all other administrators by his exceptional qualities. The king planned to set Daniel over the whole kingdom.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Jealous officials, unable to find any corruption in Daniel, devised a trap. They convinced the king to sign a decree: for thirty days, anyone who prayed to any god or human except the king would be thrown into the lions\' den.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Daniel knew the decree had been signed, yet he went home, opened his windows toward Jerusalem, and prayed three times a day — just as he had always done. The officials found him and reported him to the king.',
              'speaker': 'Narrator',
            },
            {
              'text':
                  'Though deeply distressed, King Darius was bound by his own law. Daniel was thrown into the den, and a stone was placed over its mouth. But God sent His angel to shut the lions\' mouths. At dawn, the king found Daniel alive and unharmed — and those who had accused him met the fate they had planned for him.',
              'speaker': 'Narrator',
            },
          ],
          'questions': [
            {
              'question': 'Which king was ruling when Daniel was thrown into the lions\' den?',
              'options': ['Darius', 'Nebuchadnezzar', 'Cyrus', 'Belshazzar'],
              'answer': 'Darius',
              'explanation': 'It pleased Darius to appoint 120 satraps to rule throughout the kingdom, with Daniel as one of three administrators over them.',
              'bibleReference': 'Daniel 6:1-2',
            },
            {
              'question': 'How many times a day did Daniel pray?',
              'options': ['Three times', 'Once', 'Five times', 'Seven times'],
              'answer': 'Three times',
              'explanation': 'Three times a day Daniel got down on his knees and prayed, giving thanks to his God, just as he had done before.',
              'bibleReference': 'Daniel 6:10',
            },
            {
              'question': 'Which direction did Daniel face when he prayed?',
              'options': ['Toward Jerusalem', 'Toward the east', 'Toward the temple of Darius', 'Toward the north'],
              'answer': 'Toward Jerusalem',
              'explanation': 'Daniel went to his upstairs room where the windows opened toward Jerusalem, and he prayed.',
              'bibleReference': 'Daniel 6:10',
            },
            {
              'question': 'For how many days did the decree forbid prayer to anyone except the king?',
              'options': ['Thirty days', 'Seven days', 'Forty days', 'Ten days'],
              'answer': 'Thirty days',
              'explanation': 'The decree stated that anyone who prayed to any god or human during the next thirty days, except to the king, would be thrown into the lions\' den.',
              'bibleReference': 'Daniel 6:7',
            },
            {
              'question': 'Why did the officials target Daniel with the prayer decree?',
              'options': ['They were jealous and could find no other fault in him', 'Daniel had insulted the king', 'Daniel refused to pay taxes', 'Daniel worshipped foreign gods'],
              'answer': 'They were jealous and could find no other fault in him',
              'explanation': 'They could find no corruption in Daniel because he was trustworthy, so they decided the only way to trap him was through his devotion to God.',
              'bibleReference': 'Daniel 6:4-5',
            },
            {
              'question': 'What was placed over the mouth of the lions\' den?',
              'options': ['A stone sealed with the king\'s signet ring', 'An iron gate', 'A heavy wooden door', 'A bronze covering'],
              'answer': 'A stone sealed with the king\'s signet ring',
              'explanation': 'A stone was brought and placed over the mouth of the den, and the king sealed it with his own signet ring and with the rings of his nobles.',
              'bibleReference': 'Daniel 6:17',
            },
            {
              'question': 'How did God protect Daniel in the lions\' den?',
              'options': ['He sent His angel to shut the mouths of the lions', 'He put the lions to sleep', 'He surrounded Daniel with fire', 'He made Daniel invisible to the lions'],
              'answer': 'He sent His angel to shut the mouths of the lions',
              'explanation': 'Daniel said, "My God sent his angel, and he shut the mouths of the lions. They have not hurt me."',
              'bibleReference': 'Daniel 6:22',
            },
            {
              'question': 'What did King Darius do the night Daniel was in the den?',
              'options': ['He could not eat or sleep', 'He held a feast', 'He prayed to his own gods', 'He consulted his wise men'],
              'answer': 'He could not eat or sleep',
              'explanation': 'The king returned to his palace and spent the night without eating and without any entertainment being brought to him, and he could not sleep.',
              'bibleReference': 'Daniel 6:18',
            },
            {
              'question': 'What happened to the officials who had accused Daniel?',
              'options': ['They were thrown into the lions\' den with their families', 'They were exiled from Babylon', 'They were forgiven by the king', 'They were imprisoned for life'],
              'answer': 'They were thrown into the lions\' den with their families',
              'explanation': 'The king commanded that the men who had falsely accused Daniel be brought and thrown into the lions\' den, along with their wives and children.',
              'bibleReference': 'Daniel 6:24',
            },
            {
              'question': 'What decree did King Darius issue after Daniel\'s deliverance?',
              'options': ['People must fear and reverence the God of Daniel', 'All lions in Babylon must be killed', 'No one may serve as an administrator except Daniel', 'All prayer must be directed to Daniel\'s God alone'],
              'answer': 'People must fear and reverence the God of Daniel',
              'explanation': 'King Darius wrote to all the nations and peoples of every language that they must fear and reverence the God of Daniel, for He is the living God who endures forever.',
              'bibleReference': 'Daniel 6:25-26',
            },
          ],
        },
      ],
    },
    // =========================================================
    // ARC 9: THE LIFE OF JESUS
    // =========================================================
    {
      'id': 'life_of_jesus',
      'title': 'The Life of Jesus',
      'description': 'Journey through the extraordinary life of Jesus Christ — from His miraculous birth in Bethlehem to His glorious resurrection. Experience the teachings, miracles, and sacrifice that changed the world forever.',
      'chapters': [
        {
          'id': 'birth_of_the_savior',
          'title': 'The Birth of the Savior',
          'difficulty': 'Easy',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'In the town of Nazareth, the angel Gabriel appeared to a young virgin named Mary with an astonishing message — she would conceive by the Holy Spirit and bear a son called Jesus, the Son of the Most High. Though troubled at first, Mary humbly accepted God\'s plan.', 'speaker': 'Narrator'},
            {'text': 'Joseph, a righteous man betrothed to Mary, was visited by an angel in a dream who confirmed the divine nature of Mary\'s child. He was told to name the boy Jesus, for He would save His people from their sins. Joseph obeyed and took Mary as his wife.', 'speaker': 'Narrator'},
            {'text': 'A decree from Caesar Augustus brought Mary and Joseph to Bethlehem for a census. There, in the humblest of circumstances, the Savior of the world was born and laid in a manger because there was no room at the inn.', 'speaker': 'Narrator'},
            {'text': 'Shepherds in nearby fields received the glorious news from angels, and wise men from the East followed a star to worship the newborn King. But King Herod, threatened by the birth of a rival king, plotted to destroy the child, forcing the family to flee to Egypt.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'What was the name of the angel who appeared to Mary to announce that she would bear a son?',
              'options': ['Michael', 'Gabriel', 'Raphael', 'Uriel'],
              'answer': 'Gabriel',
              'explanation': 'The angel Gabriel was sent by God to Nazareth to tell Mary she had found favor with God and would conceive and bear a son named Jesus.',
              'bibleReference': 'Luke 1:26-31',
            },
            {
              'question': 'In what town was Jesus born?',
              'options': ['Nazareth', 'Jerusalem', 'Bethlehem', 'Capernaum'],
              'answer': 'Bethlehem',
              'explanation': 'Jesus was born in Bethlehem of Judea, fulfilling the prophecy of Micah. Mary and Joseph traveled there because of a Roman census.',
              'bibleReference': 'Luke 2:4-7',
            },
            {
              'question': 'Why was there no room for Mary and Joseph when they arrived in Bethlehem?',
              'options': ['The city was under siege', 'There was no room at the inn', 'A festival was taking place', 'They arrived too late at night'],
              'answer': 'There was no room at the inn',
              'explanation': 'Because of the census, Bethlehem was crowded with travelers. There was no room for Mary and Joseph at the inn, so Jesus was born and laid in a manger.',
              'bibleReference': 'Luke 2:7',
            },
            {
              'question': 'Where was baby Jesus laid after His birth?',
              'options': ['A cradle', 'A basket', 'A manger', 'A bed of straw'],
              'answer': 'A manger',
              'explanation': 'Mary wrapped Jesus in swaddling cloths and laid Him in a manger — a feeding trough for animals — because there was no room at the inn.',
              'bibleReference': 'Luke 2:7',
            },
            {
              'question': 'Who were the first people to visit the newborn Jesus after being told of His birth by angels?',
              'options': ['The wise men', 'The shepherds', 'The priests', 'Roman soldiers'],
              'answer': 'The shepherds',
              'explanation': 'Angels appeared to shepherds keeping watch over their flocks at night, announcing the birth of the Savior. The shepherds hurried to Bethlehem and found baby Jesus.',
              'bibleReference': 'Luke 2:8-16',
            },
            {
              'question': 'What guided the wise men from the East to the place where Jesus was?',
              'options': ['A pillar of fire', 'An angel', 'A star', 'A dream'],
              'answer': 'A star',
              'explanation': 'The wise men saw a star in the East that signaled the birth of the King of the Jews. They followed it until it stopped over the place where the child was.',
              'bibleReference': 'Matthew 2:1-2, 9-10',
            },
            {
              'question': 'Which king tried to find and kill the baby Jesus?',
              'options': ['Herod', 'Pilate', 'Caesar Augustus', 'Pharaoh'],
              'answer': 'Herod',
              'explanation': 'King Herod was deeply troubled when he heard a new king had been born. He secretly plotted to find and kill the child to eliminate any threat to his throne.',
              'bibleReference': 'Matthew 2:13-16',
            },
            {
              'question': 'Where did Joseph take Mary and Jesus to escape from King Herod?',
              'options': ['Syria', 'Persia', 'Egypt', 'Greece'],
              'answer': 'Egypt',
              'explanation': 'An angel appeared to Joseph in a dream, warning him to take the child and His mother and flee to Egypt. They stayed there until Herod died.',
              'bibleReference': 'Matthew 2:13-15',
            },
            {
              'question': 'How was Joseph told to take Mary as his wife despite her unexpected pregnancy?',
              'options': ['Through a letter from the priests', 'By an angel in a dream', 'By a prophet\'s message', 'Through a vision in the temple'],
              'answer': 'By an angel in a dream',
              'explanation': 'An angel of the Lord appeared to Joseph in a dream, telling him not to be afraid to take Mary as his wife because the child conceived in her was from the Holy Spirit.',
              'bibleReference': 'Matthew 1:20-21',
            },
            {
              'question': 'What does the name "Jesus" mean?',
              'options': ['God is great', 'Prince of Peace', 'He will save His people from their sins', 'Anointed One'],
              'answer': 'He will save His people from their sins',
              'explanation': 'The angel told Joseph to name the child Jesus, which means "the Lord saves," because He would save His people from their sins.',
              'bibleReference': 'Matthew 1:21',
            },
          ],
        },
        {
          'id': 'baptism_and_temptation',
          'title': 'Baptism and Temptation',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'In the wilderness of Judea, a prophet named John the Baptist called the people to repentance, baptizing them in the Jordan River. He proclaimed that one far greater was coming — one who would baptize not with water, but with the Holy Spirit and fire.', 'speaker': 'Narrator'},
            {'text': 'Jesus came from Galilee to the Jordan to be baptized by John. Though John felt unworthy, Jesus insisted, saying it was fitting to fulfill all righteousness. As Jesus came up out of the water, the heavens opened and the Spirit of God descended upon Him like a dove.', 'speaker': 'Narrator'},
            {'text': 'A voice from heaven declared, "This is my beloved Son, in whom I am well pleased." This powerful moment marked the beginning of Jesus\' public ministry, affirmed by the Father and empowered by the Spirit.', 'speaker': 'Narrator'},
            {'text': 'Immediately after, the Spirit led Jesus into the wilderness where He fasted for forty days and forty nights. There, Satan came to tempt Him three times, but Jesus overcame each temptation by standing firm on the Word of God.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'Who baptized Jesus in the Jordan River?',
              'options': ['Peter', 'John the Baptist', 'Andrew', 'James'],
              'answer': 'John the Baptist',
              'explanation': 'John the Baptist was the prophet who baptized Jesus in the Jordan River. Though he initially objected, Jesus told him it was proper to fulfill all righteousness.',
              'bibleReference': 'Matthew 3:13-15',
            },
            {
              'question': 'In what form did the Holy Spirit descend upon Jesus after His baptism?',
              'options': ['A flame of fire', 'A dove', 'A rushing wind', 'A bright cloud'],
              'answer': 'A dove',
              'explanation': 'After Jesus was baptized, the heavens opened and the Spirit of God descended upon Him like a dove, visibly confirming His identity and anointing.',
              'bibleReference': 'Matthew 3:16',
            },
            {
              'question': 'What did the voice from heaven say at Jesus\' baptism?',
              'options': ['Behold the Lamb of God', 'This is my beloved Son, in whom I am well pleased', 'You are the chosen one of Israel', 'Go and preach to all nations'],
              'answer': 'This is my beloved Son, in whom I am well pleased',
              'explanation': 'God the Father spoke audibly from heaven, affirming Jesus as His beloved Son and expressing His pleasure in Him.',
              'bibleReference': 'Matthew 3:17',
            },
            {
              'question': 'How many days did Jesus fast in the wilderness before being tempted?',
              'options': ['7 days', '21 days', '40 days', '12 days'],
              'answer': '40 days',
              'explanation': 'Jesus was led by the Spirit into the wilderness where He fasted for forty days and forty nights. After this extended fast, He was hungry and the tempter came to Him.',
              'bibleReference': 'Matthew 4:1-2',
            },
            {
              'question': 'In the first temptation, what did Satan tell Jesus to turn into bread?',
              'options': ['Water', 'Stones', 'Sand', 'Dust'],
              'answer': 'Stones',
              'explanation': 'Satan tempted the hungry Jesus by saying, "If you are the Son of God, tell these stones to become bread." Jesus refused, quoting Scripture.',
              'bibleReference': 'Matthew 4:3',
            },
            {
              'question': 'How did Jesus respond to Satan\'s first temptation about turning stones into bread?',
              'options': ['Get behind me, Satan', 'Man shall not live by bread alone, but by every word that proceeds from the mouth of God', 'You shall not put the Lord your God to the test', 'The Lord your God is one'],
              'answer': 'Man shall not live by bread alone, but by every word that proceeds from the mouth of God',
              'explanation': 'Jesus quoted Deuteronomy 8:3, affirming that physical sustenance is not as important as spiritual nourishment from God\'s Word.',
              'bibleReference': 'Matthew 4:4',
            },
            {
              'question': 'Where did Satan take Jesus for the second temptation?',
              'options': ['The top of a mountain', 'The pinnacle of the temple', 'The banks of the Jordan', 'The gates of Jerusalem'],
              'answer': 'The pinnacle of the temple',
              'explanation': 'Satan took Jesus to the pinnacle of the temple in Jerusalem and challenged Him to throw Himself down, misquoting Scripture about angelic protection.',
              'bibleReference': 'Matthew 4:5-6',
            },
            {
              'question': 'In the third temptation, what did Satan offer Jesus in exchange for worship?',
              'options': ['Eternal life', 'All the kingdoms of the world', 'Command over the angels', 'The throne of David'],
              'answer': 'All the kingdoms of the world',
              'explanation': 'Satan showed Jesus all the kingdoms of the world and their splendor, offering to give them all to Jesus if He would bow down and worship him.',
              'bibleReference': 'Matthew 4:8-9',
            },
            {
              'question': 'What final command did Jesus give Satan after the third temptation?',
              'options': ['Leave me alone', 'Away from me, Satan!', 'You have no power here', 'I rebuke you in God\'s name'],
              'answer': 'Away from me, Satan!',
              'explanation': 'Jesus commanded Satan to leave, saying "Away from me, Satan! For it is written: Worship the Lord your God, and serve him only."',
              'bibleReference': 'Matthew 4:10',
            },
            {
              'question': 'Who came to attend to Jesus after Satan left Him in the wilderness?',
              'options': ['The disciples', 'Angels', 'John the Baptist', 'Moses and Elijah'],
              'answer': 'Angels',
              'explanation': 'After Satan departed, angels came and attended to Jesus, ministering to Him after His forty days of fasting and the ordeal of temptation.',
              'bibleReference': 'Matthew 4:11',
            },
          ],
        },
        {
          'id': 'miracles_and_teachings',
          'title': 'Miracles and Teachings',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'Jesus began His public ministry with authority and power. On a mountainside in Galilee, He delivered the greatest sermon ever preached — the Sermon on the Mount. He taught about the Kingdom of God, blessing the poor in spirit, the meek, and the peacemakers.', 'speaker': 'Narrator'},
            {'text': 'The miracles of Jesus revealed His divine authority over nature, sickness, and death. He fed five thousand people with just five loaves and two fish, walked on the stormy Sea of Galilee, and calmed a raging tempest with a single command.', 'speaker': 'Narrator'},
            {'text': 'Jesus healed the blind, the lame, and the sick wherever He went. He touched the untouchable, spoke to the outcast, and showed compassion to all. His miracles were signs pointing to a greater truth — that the Kingdom of God had come near.', 'speaker': 'Narrator'},
            {'text': 'Through parables and powerful teachings, Jesus challenged the religious leaders and inspired the common people. He called twelve ordinary men to be His disciples and sent them out to share the good news of the Kingdom.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'What is the name of the famous sermon Jesus preached on a mountainside?',
              'options': ['The Sermon on the Plain', 'The Sermon on the Mount', 'The Great Commission', 'The Olivet Discourse'],
              'answer': 'The Sermon on the Mount',
              'explanation': 'The Sermon on the Mount is found in Matthew chapters 5 through 7. Jesus taught about the Beatitudes, prayer, loving enemies, and living as citizens of God\'s Kingdom.',
              'bibleReference': 'Matthew 5:1-2',
            },
            {
              'question': 'In the Beatitudes, Jesus said "Blessed are the meek." What did He say they would inherit?',
              'options': ['The Kingdom of Heaven', 'Eternal life', 'The earth', 'God\'s favor'],
              'answer': 'The earth',
              'explanation': 'Jesus taught, "Blessed are the meek, for they will inherit the earth," promising that those who are humble and gentle will receive God\'s ultimate reward.',
              'bibleReference': 'Matthew 5:5',
            },
            {
              'question': 'How many loaves of bread were used to feed the five thousand?',
              'options': ['Three', 'Five', 'Seven', 'Two'],
              'answer': 'Five',
              'explanation': 'A boy had five barley loaves and two small fish. Jesus took them, gave thanks, and miraculously multiplied them to feed over five thousand people.',
              'bibleReference': 'John 6:9-11',
            },
            {
              'question': 'How many baskets of leftovers were collected after the feeding of the five thousand?',
              'options': ['Seven', 'Five', 'Twelve', 'Three'],
              'answer': 'Twelve',
              'explanation': 'After everyone had eaten their fill, the disciples collected twelve baskets full of leftover fragments, demonstrating the abundance of Jesus\' provision.',
              'bibleReference': 'Matthew 14:20',
            },
            {
              'question': 'Which disciple walked on water toward Jesus before becoming afraid and sinking?',
              'options': ['John', 'James', 'Peter', 'Andrew'],
              'answer': 'Peter',
              'explanation': 'When Peter saw Jesus walking on the water, he asked to come to Him. Jesus said "Come," and Peter walked on the water but became afraid of the wind and began to sink.',
              'bibleReference': 'Matthew 14:28-31',
            },
            {
              'question': 'What did Jesus say to calm the storm on the Sea of Galilee?',
              'options': ['Peace, be still', 'Be calm, waters', 'I command you to stop', 'Cease, O wind'],
              'answer': 'Peace, be still',
              'explanation': 'While the disciples panicked in the storm, Jesus rebuked the wind and said to the sea, "Peace, be still!" and there was a great calm.',
              'bibleReference': 'Mark 4:39',
            },
            {
              'question': 'What question did the disciples ask after Jesus calmed the storm?',
              'options': ['Are you the Messiah?', 'Who then is this, that even the wind and the sea obey Him?', 'How did you do that?', 'Should we follow you forever?'],
              'answer': 'Who then is this, that even the wind and the sea obey Him?',
              'explanation': 'The disciples were filled with great fear and awe, asking each other who this man could be that even the wind and the sea obeyed His commands.',
              'bibleReference': 'Mark 4:41',
            },
            {
              'question': 'In the Sermon on the Mount, what did Jesus teach His followers to do to their enemies?',
              'options': ['Avoid them', 'Report them to authorities', 'Love them', 'Ignore them'],
              'answer': 'Love them',
              'explanation': 'Jesus taught a radical ethic of love, commanding His followers to love their enemies and pray for those who persecute them.',
              'bibleReference': 'Matthew 5:44',
            },
            {
              'question': 'What did Jesus use to heal the man who was born blind in the Gospel of John?',
              'options': ['A word of command', 'Mud made with saliva', 'Anointing oil', 'The hem of His garment'],
              'answer': 'Mud made with saliva',
              'explanation': 'Jesus spat on the ground, made mud with the saliva, and applied it to the blind man\'s eyes. He then told the man to wash in the Pool of Siloam, and he received his sight.',
              'bibleReference': 'John 9:6-7',
            },
          ],
        },
        {
          'id': 'last_supper_and_betrayal',
          'title': 'The Last Supper and Betrayal',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'As the Passover feast drew near, Jesus entered Jerusalem riding on a donkey while crowds spread palm branches and cloaks on the road, shouting praises. This triumphal entry fulfilled ancient prophecy, yet the religious leaders grew more determined to stop Him.', 'speaker': 'Narrator'},
            {'text': 'On the night before His crucifixion, Jesus gathered His twelve disciples for the Passover meal. In an extraordinary act of humility, He wrapped a towel around His waist and washed each disciple\'s feet, teaching them to serve one another.', 'speaker': 'Narrator'},
            {'text': 'During the meal, Jesus took bread, gave thanks, broke it, and gave it to His disciples saying it was His body given for them. He then took the cup, calling it the new covenant in His blood. This sacred meal would be remembered for all generations.', 'speaker': 'Narrator'},
            {'text': 'Jesus revealed that one of the twelve would betray Him. That night, Judas Iscariot left to carry out his treachery for thirty pieces of silver. In the Garden of Gethsemane, Jesus prayed in agony while His disciples slept, and soon the betrayer arrived with an armed crowd.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'What animal did Jesus ride when He entered Jerusalem?',
              'options': ['A horse', 'A camel', 'A donkey', 'A mule'],
              'answer': 'A donkey',
              'explanation': 'Jesus rode into Jerusalem on a donkey, fulfilling the prophecy of Zechariah 9:9 that the King would come riding on a donkey, humble and mounted on a colt.',
              'bibleReference': 'Matthew 21:1-7',
            },
            {
              'question': 'What did the crowds spread on the road as Jesus entered Jerusalem?',
              'options': ['Flowers and petals', 'Palm branches and cloaks', 'Gold coins', 'Red carpets'],
              'answer': 'Palm branches and cloaks',
              'explanation': 'The crowds cut branches from palm trees and spread them on the road, along with their cloaks, as a sign of honor and royal welcome for Jesus.',
              'bibleReference': 'Matthew 21:8; John 12:13',
            },
            {
              'question': 'What humble act did Jesus perform for His disciples at the Last Supper?',
              'options': ['He cooked the meal', 'He washed their feet', 'He anointed their heads', 'He served them wine'],
              'answer': 'He washed their feet',
              'explanation': 'Jesus wrapped a towel around His waist, poured water into a basin, and washed His disciples\' feet, teaching them that true leadership means humble service.',
              'bibleReference': 'John 13:4-5, 14-15',
            },
            {
              'question': 'What did Jesus say the bread represented at the Last Supper?',
              'options': ['The Word of God', 'His body', 'The manna from heaven', 'The Passover lamb'],
              'answer': 'His body',
              'explanation': 'Jesus took bread, gave thanks, broke it, and said, "This is my body given for you; do this in remembrance of me."',
              'bibleReference': 'Luke 22:19',
            },
            {
              'question': 'What did Jesus say the cup of wine represented?',
              'options': ['The blood of the Passover lamb', 'The new covenant in His blood', 'The joy of the Kingdom', 'The wrath of God'],
              'answer': 'The new covenant in His blood',
              'explanation': 'Jesus took the cup and said, "This cup is the new covenant in my blood, which is poured out for you," establishing the new covenant through His sacrifice.',
              'bibleReference': 'Luke 22:20',
            },
            {
              'question': 'How much was Judas paid to betray Jesus?',
              'options': ['Ten pieces of silver', 'Twenty pieces of gold', 'Thirty pieces of silver', 'Fifty pieces of silver'],
              'answer': 'Thirty pieces of silver',
              'explanation': 'Judas Iscariot went to the chief priests and agreed to betray Jesus for thirty pieces of silver, fulfilling the prophecy in Zechariah 11:12.',
              'bibleReference': 'Matthew 26:14-15',
            },
            {
              'question': 'How did Judas identify Jesus to the soldiers in the Garden of Gethsemane?',
              'options': ['He pointed at Him', 'He kissed Him', 'He called out His name', 'He handed them a description'],
              'answer': 'He kissed Him',
              'explanation': 'Judas had arranged a signal with the soldiers, saying, "The one I kiss is the man; arrest him." He approached Jesus and kissed Him to identify Him.',
              'bibleReference': 'Matthew 26:48-49',
            },
            {
              'question': 'What did Jesus predict Peter would do before the rooster crowed?',
              'options': ['Flee from Jerusalem', 'Deny Jesus three times', 'Fall asleep in the garden', 'Draw his sword in anger'],
              'answer': 'Deny Jesus three times',
              'explanation': 'Jesus told Peter, "Before the rooster crows, you will disown me three times." Peter insisted he would never deny the Lord, but it happened exactly as Jesus said.',
              'bibleReference': 'Matthew 26:34',
            },
            {
              'question': 'What was the name of the garden where Jesus prayed before His arrest?',
              'options': ['The Garden of Eden', 'The Garden of Gethsemane', 'The Garden of Olives', 'The King\'s Garden'],
              'answer': 'The Garden of Gethsemane',
              'explanation': 'Jesus went with His disciples to a place called Gethsemane, located on the Mount of Olives. There He prayed in deep anguish about the suffering ahead.',
              'bibleReference': 'Matthew 26:36',
            },
            {
              'question': 'What were the disciples doing while Jesus prayed in the garden?',
              'options': ['Praying with Him', 'Sleeping', 'Keeping watch at the gate', 'Arguing among themselves'],
              'answer': 'Sleeping',
              'explanation': 'Despite Jesus asking them to stay awake and keep watch, the disciples fell asleep. He found them sleeping three times and said, "The spirit is willing, but the flesh is weak."',
              'bibleReference': 'Matthew 26:40-43',
            },
          ],
        },
        {
          'id': 'cross_and_resurrection',
          'title': 'The Cross and Resurrection',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'After a series of unjust trials before the Jewish council and the Roman governor Pontius Pilate, Jesus was sentenced to death by crucifixion. He was mocked, beaten, and forced to carry His own cross through the streets of Jerusalem toward Golgotha.', 'speaker': 'Narrator'},
            {'text': 'At the place called the Skull, Jesus was nailed to the cross between two criminals. A sign was placed above His head reading "Jesus of Nazareth, the King of the Jews." Even in His suffering, Jesus prayed for His executioners and promised paradise to a repentant thief.', 'speaker': 'Narrator'},
            {'text': 'Darkness covered the land for three hours. When Jesus breathed His last, the curtain of the temple was torn in two from top to bottom, and the earth shook. A Roman centurion declared, "Surely this man was the Son of God." Jesus was buried in a tomb belonging to Joseph of Arimathea.', 'speaker': 'Narrator'},
            {'text': 'On the third day, women came to the tomb at dawn and found the stone rolled away and the tomb empty. Angels announced the most glorious news in all of history — Jesus had risen from the dead! He appeared to Mary Magdalene, to His disciples, and to many others, proving that death could not hold Him.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'Who was forced to carry the cross of Jesus on the way to the crucifixion?',
              'options': ['Peter', 'Barabbas', 'Simon of Cyrene', 'John'],
              'answer': 'Simon of Cyrene',
              'explanation': 'The Roman soldiers seized Simon of Cyrene, a man passing by from the country, and forced him to carry the cross behind Jesus on the way to Golgotha.',
              'bibleReference': 'Matthew 27:32',
            },
            {
              'question': 'What was written on the sign placed above Jesus on the cross?',
              'options': ['King of Kings', 'Jesus of Nazareth, the King of the Jews', 'The Son of God', 'This is the Messiah'],
              'answer': 'Jesus of Nazareth, the King of the Jews',
              'explanation': 'Pilate had a notice prepared and fastened to the cross. It read: "Jesus of Nazareth, the King of the Jews," written in Aramaic, Latin, and Greek.',
              'bibleReference': 'John 19:19',
            },
            {
              'question': 'What happened in the temple when Jesus died on the cross?',
              'options': ['The altar crumbled', 'The curtain was torn in two from top to bottom', 'The temple collapsed', 'Fire came down from heaven'],
              'answer': 'The curtain was torn in two from top to bottom',
              'explanation': 'At the moment of Jesus\' death, the curtain of the temple was torn in two from top to bottom, symbolizing that access to God was now open to all people through Christ.',
              'bibleReference': 'Matthew 27:51',
            },
            {
              'question': 'Who provided the tomb where Jesus was buried?',
              'options': ['Nicodemus', 'Joseph of Arimathea', 'Simon Peter', 'Lazarus'],
              'answer': 'Joseph of Arimathea',
              'explanation': 'Joseph of Arimathea, a wealthy and respected member of the council who was a secret disciple of Jesus, asked Pilate for the body and placed it in his own new tomb.',
              'bibleReference': 'Matthew 27:57-60',
            },
            {
              'question': 'Who was the first person to see the risen Jesus?',
              'options': ['Peter', 'John', 'Mary Magdalene', 'Mary the mother of Jesus'],
              'answer': 'Mary Magdalene',
              'explanation': 'Mary Magdalene went to the tomb early on Sunday morning. After finding it empty, the risen Jesus appeared to her first, and she went to tell the disciples.',
              'bibleReference': 'John 20:11-18; Mark 16:9',
            },
            {
              'question': 'Which disciple doubted the resurrection until he saw Jesus\' wounds?',
              'options': ['Peter', 'Thomas', 'Andrew', 'Philip'],
              'answer': 'Thomas',
              'explanation': 'Thomas was not present when Jesus first appeared to the disciples. He declared he would not believe until he saw and touched the nail marks. When Jesus appeared again, Thomas believed and exclaimed, "My Lord and my God!"',
              'bibleReference': 'John 20:24-28',
            },
            {
              'question': 'How many days after His death did Jesus rise from the dead?',
              'options': ['One day', 'Two days', 'Three days', 'Seven days'],
              'answer': 'Three days',
              'explanation': 'Jesus rose from the dead on the third day, just as He had predicted. He was crucified on Friday and rose early on Sunday morning.',
              'bibleReference': 'Matthew 28:1-6; Luke 24:7',
            },
            {
              'question': 'What did the Roman centurion say after witnessing Jesus\' death?',
              'options': ['This was a righteous man', 'Surely this man was the Son of God', 'We have made a terrible mistake', 'His God has abandoned Him'],
              'answer': 'Surely this man was the Son of God',
              'explanation': 'When the centurion who stood at the cross witnessed how Jesus died and the signs that accompanied His death, he declared, "Surely this man was the Son of God!"',
              'bibleReference': 'Mark 15:39',
            },
            {
              'question': 'What was found inside the tomb when the women arrived on Sunday morning?',
              'options': ['The body of Jesus wrapped in cloth', 'Roman soldiers guarding the body', 'An angel sitting where Jesus had lain', 'Nothing at all'],
              'answer': 'An angel sitting where Jesus had lain',
              'explanation': 'When the women entered the tomb, they saw an angel in white who told them not to be afraid — Jesus had risen, just as He said He would.',
              'bibleReference': 'Matthew 28:2-6',
            },
            {
              'question': 'On the road to Emmaus, two disciples walked with the risen Jesus without recognizing Him. When did they finally recognize Him?',
              'options': ['When He called them by name', 'When He broke bread', 'When He showed them His wounds', 'When He quoted Scripture'],
              'answer': 'When He broke bread',
              'explanation': 'The two disciples did not recognize Jesus as they walked together. But when He sat at the table with them, took bread, blessed and broke it, their eyes were opened and they recognized Him.',
              'bibleReference': 'Luke 24:30-31',
            },
          ],
        },
      ],
    },
    // =========================================================
    // ARC 10: THE JUDGES OF ISRAEL
    // =========================================================
    {
      'id': 'judges_of_israel',
      'title': 'The Judges of Israel',
      'description': 'Experience the era when God raised up mighty judges to deliver Israel from oppression. From Deborah\'s wisdom to Gideon\'s faith and Samson\'s extraordinary strength, witness how God used unlikely heroes to save His people.',
      'chapters': [
        {
          'id': 'deborah_the_judge',
          'title': 'Deborah the Judge',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'After the death of Ehud, the Israelites once again did evil in the sight of the Lord. God allowed them to fall under the cruel hand of Jabin, king of Canaan, whose mighty general Sisera commanded nine hundred chariots of iron. For twenty long years, Israel groaned under this oppression.', 'speaker': 'Narrator'},
            {'text': 'But God had not forgotten His people. In those dark days, a woman of extraordinary faith and wisdom arose. Deborah, a prophetess and the wife of Lappidoth, judged Israel from beneath a palm tree in the hill country of Ephraim. The people came to her from across the land seeking justice and the word of the Lord.', 'speaker': 'Narrator'},
            {'text': 'Deborah summoned Barak son of Abinoam and delivered God\'s command to gather ten thousand men and march against Sisera. But Barak hesitated, declaring he would only go if Deborah went with him. She agreed but prophesied that the honor of the victory would belong not to Barak, but to a woman.', 'speaker': 'Narrator'},
            {'text': 'The Lord routed Sisera\'s army before Barak, and the mighty general fled on foot. He sought refuge in the tent of Jael, wife of Heber the Kenite. While Sisera slept from exhaustion, Jael drove a tent peg through his temple. That day, God subdued Jabin king of Canaan before the Israelites, and Deborah and Barak sang a triumphant song of praise.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'Under what type of tree did Deborah sit when she judged Israel?',
              'options': ['Oak tree', 'Palm tree', 'Fig tree', 'Olive tree'],
              'answer': 'Palm tree',
              'explanation': 'Deborah held court under the Palm of Deborah, between Ramah and Bethel in the hill country of Ephraim.',
              'bibleReference': 'Judges 4:5',
            },
            {
              'question': 'Who was the commander of King Jabin\'s army?',
              'options': ['Barak', 'Sisera', 'Heber', 'Lappidoth'],
              'answer': 'Sisera',
              'explanation': 'Sisera was the commander of the army of Jabin, king of Canaan, who reigned in Hazor.',
              'bibleReference': 'Judges 4:2',
            },
            {
              'question': 'How many chariots of iron did Sisera command?',
              'options': ['Three hundred', 'Six hundred', 'Nine hundred', 'One thousand two hundred'],
              'answer': 'Nine hundred',
              'explanation': 'Sisera had nine hundred chariots of iron, and he cruelly oppressed the Israelites for twenty years.',
              'bibleReference': 'Judges 4:3',
            },
            {
              'question': 'What condition did Barak set before he would go to battle?',
              'options': ['That he receive a sign from heaven', 'That Deborah go with him', 'That he have twenty thousand soldiers', 'That the Philistines be defeated first'],
              'answer': 'That Deborah go with him',
              'explanation': 'Barak told Deborah, "If you go with me, I will go; but if you don\'t go with me, I won\'t go."',
              'bibleReference': 'Judges 4:8',
            },
            {
              'question': 'According to Deborah\'s prophecy, who would receive the honor of defeating Sisera?',
              'options': ['Barak', 'A woman', 'The angel of the Lord', 'The tribe of Ephraim'],
              'answer': 'A woman',
              'explanation': 'Deborah told Barak that because of his reluctance, the Lord would deliver Sisera into the hands of a woman.',
              'bibleReference': 'Judges 4:9',
            },
            {
              'question': 'How many men did Barak gather to fight Sisera at Mount Tabor?',
              'options': ['Five thousand', 'Ten thousand', 'Twenty thousand', 'Thirty thousand'],
              'answer': 'Ten thousand',
              'explanation': 'Barak summoned the tribes of Zebulun and Naphtali and gathered ten thousand men to march to Mount Tabor.',
              'bibleReference': 'Judges 4:10',
            },
            {
              'question': 'Who killed Sisera after he fled from the battle?',
              'options': ['Deborah', 'Barak', 'Jael', 'Heber'],
              'answer': 'Jael',
              'explanation': 'Jael, the wife of Heber the Kenite, invited Sisera into her tent and drove a tent peg through his temple while he slept.',
              'bibleReference': 'Judges 4:21',
            },
            {
              'question': 'What weapon did Jael use to kill Sisera?',
              'options': ['A sword', 'A tent peg and hammer', 'A spear', 'A bow and arrow'],
              'answer': 'A tent peg and hammer',
              'explanation': 'Jael picked up a tent peg and a hammer and drove the peg through Sisera\'s temple into the ground while he lay sleeping.',
              'bibleReference': 'Judges 4:21',
            },
            {
              'question': 'What did Deborah and Barak do after the victory over Sisera?',
              'options': ['Built an altar', 'Sang a song of praise', 'Made a burnt offering', 'Crossed the Jordan River'],
              'answer': 'Sang a song of praise',
              'explanation': 'On that day Deborah and Barak son of Abinoam sang a triumphant song praising God for the victory over their enemies.',
              'bibleReference': 'Judges 5:1',
            },
            {
              'question': 'Who was the king of Canaan that oppressed Israel during Deborah\'s time?',
              'options': ['Abimelech', 'Jabin', 'Eglon', 'Cushan-Rishathaim'],
              'answer': 'Jabin',
              'explanation': 'Jabin, king of Canaan, who reigned in Hazor, had cruelly oppressed the Israelites for twenty years.',
              'bibleReference': 'Judges 4:2-3',
            },
          ],
        },
        {
          'id': 'gideons_300',
          'title': 'Gideon\'s 300',
          'difficulty': 'Medium',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'The Midianites had invaded Israel like swarms of locusts, destroying crops and livestock until the people were driven into caves and mountain strongholds. In desperation, Israel cried out to God. The angel of the Lord appeared to a young man named Gideon as he threshed wheat in a winepress, hiding from the enemy.', 'speaker': 'Narrator'},
            {'text': 'The angel called Gideon a mighty warrior, but Gideon doubted. He asked for a sign and placed a wool fleece on the threshing floor. First he asked God to make only the fleece wet while the ground stayed dry, and then he reversed the test. Both times God answered, confirming His call upon Gideon\'s life.', 'speaker': 'Narrator'},
            {'text': 'Gideon assembled an army of thirty-two thousand men, but God said there were too many. After sending home the fearful, ten thousand remained. God reduced the army further by testing how the men drank water. Only three hundred men who lapped the water with their hands to their mouths were chosen for battle.', 'speaker': 'Narrator'},
            {'text': 'With just three hundred men carrying trumpets, empty jars, and torches, Gideon surrounded the Midianite camp at night. At his signal, they blew their trumpets, smashed their jars, and held up their torches, shouting, "A sword for the Lord and for Gideon!" The Midianites turned on each other in confusion and fled, and Israel was delivered.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'What was Gideon doing when the angel of the Lord appeared to him?',
              'options': ['Tending sheep', 'Threshing wheat in a winepress', 'Plowing a field', 'Drawing water from a well'],
              'answer': 'Threshing wheat in a winepress',
              'explanation': 'Gideon was threshing wheat in a winepress to keep it hidden from the Midianites when the angel appeared.',
              'bibleReference': 'Judges 6:11',
            },
            {
              'question': 'What did the angel of the Lord call Gideon?',
              'options': ['A humble servant', 'A mighty warrior', 'A faithful prophet', 'A chosen king'],
              'answer': 'A mighty warrior',
              'explanation': 'The angel of the Lord greeted Gideon by saying, "The Lord is with you, mighty warrior."',
              'bibleReference': 'Judges 6:12',
            },
            {
              'question': 'What did Gideon place on the threshing floor to test God\'s promise?',
              'options': ['A stone', 'A wool fleece', 'A piece of bread', 'An offering of grain'],
              'answer': 'A wool fleece',
              'explanation': 'Gideon placed a wool fleece on the threshing floor and asked God to make it wet with dew while the ground remained dry as a sign.',
              'bibleReference': 'Judges 6:37',
            },
            {
              'question': 'How many men did Gideon originally gather for his army?',
              'options': ['Ten thousand', 'Twenty thousand', 'Thirty-two thousand', 'Forty thousand'],
              'answer': 'Thirty-two thousand',
              'explanation': 'Gideon initially assembled thirty-two thousand men, but God said there were too many lest Israel boast that their own strength saved them.',
              'bibleReference': 'Judges 7:3',
            },
            {
              'question': 'How many soldiers remained after the fearful were sent home?',
              'options': ['Three hundred', 'One thousand', 'Ten thousand', 'Twenty thousand'],
              'answer': 'Ten thousand',
              'explanation': 'Twenty-two thousand men left after Gideon announced that anyone who was afraid could go home, leaving ten thousand.',
              'bibleReference': 'Judges 7:3',
            },
            {
              'question': 'How did God tell Gideon to choose the final group of soldiers?',
              'options': ['By their height and strength', 'By how they drank water', 'By their skill with a sword', 'By casting lots'],
              'answer': 'By how they drank water',
              'explanation': 'God told Gideon to take the men to the water. Those who lapped water with their hands to their mouths were separated from those who knelt down to drink.',
              'bibleReference': 'Judges 7:5-6',
            },
            {
              'question': 'How many men were in Gideon\'s final army?',
              'options': ['One hundred', 'Three hundred', 'Five hundred', 'One thousand'],
              'answer': 'Three hundred',
              'explanation': 'Only three hundred men lapped the water with their hands to their mouths, and God said He would use them to save Israel.',
              'bibleReference': 'Judges 7:7',
            },
            {
              'question': 'What three items did Gideon\'s men carry into battle?',
              'options': ['Swords, shields, and spears', 'Trumpets, jars, and torches', 'Bows, arrows, and horns', 'Ropes, slings, and stones'],
              'answer': 'Trumpets, jars, and torches',
              'explanation': 'Each of the three hundred men was given a trumpet, an empty jar, and a torch to place inside the jar.',
              'bibleReference': 'Judges 7:16',
            },
            {
              'question': 'What happened to the Midianites when Gideon\'s men blew their trumpets and smashed their jars?',
              'options': ['They surrendered immediately', 'They turned on each other in confusion', 'They charged at Gideon\'s men', 'They called for reinforcements'],
              'answer': 'They turned on each other in confusion',
              'explanation': 'The Lord caused the Midianites to turn their swords against each other in panic and confusion, and the entire army fled.',
              'bibleReference': 'Judges 7:22',
            },
            {
              'question': 'Which people had been oppressing Israel before God called Gideon?',
              'options': ['The Philistines', 'The Egyptians', 'The Midianites', 'The Amalekites'],
              'answer': 'The Midianites',
              'explanation': 'The Midianites had invaded and devastated Israel\'s land for seven years before God raised up Gideon as deliverer.',
              'bibleReference': 'Judges 6:1-2',
            },
          ],
        },
        {
          'id': 'samson_the_strong',
          'title': 'Samson the Strong',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'In the days when the Philistines ruled over Israel, the angel of the Lord appeared to a barren woman from the tribe of Dan and her husband Manoah. The angel promised them a son who would be set apart as a Nazirite from birth. He was never to drink wine, eat anything unclean, or cut his hair, for he would begin the deliverance of Israel from the Philistines.', 'speaker': 'Narrator'},
            {'text': 'The child was born and named Samson, and the Spirit of the Lord began to stir him. As a young man, Samson encountered a young lion that came roaring toward him. The Spirit of the Lord came upon him mightily, and he tore the lion apart with his bare hands as one would tear a young goat.', 'speaker': 'Narrator'},
            {'text': 'Later, Samson found that bees had made honey in the carcass of the lion. From this he crafted a riddle for his Philistine wedding guests: "Out of the eater, something to eat; out of the strong, something sweet." When the Philistines could not solve it, they pressured his wife until she revealed the answer, igniting Samson\'s fury against them.', 'speaker': 'Narrator'},
            {'text': 'Samson\'s exploits against the Philistines became legendary. He caught three hundred foxes, tied torches to their tails, and set the Philistine fields ablaze. When the Philistines came against him, the Spirit of the Lord rushed upon him, and he struck down a thousand men with the jawbone of a donkey, declaring that God had granted this great victory.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'To which Israelite tribe did Samson\'s family belong?',
              'options': ['Judah', 'Benjamin', 'Dan', 'Ephraim'],
              'answer': 'Dan',
              'explanation': 'Samson\'s father Manoah was from Zorah, a city of the tribe of Dan.',
              'bibleReference': 'Judges 13:2',
            },
            {
              'question': 'Who appeared to Samson\'s mother to announce his birth?',
              'options': ['A priest', 'The angel of the Lord', 'The prophet Samuel', 'A Levite'],
              'answer': 'The angel of the Lord',
              'explanation': 'The angel of the Lord appeared to Manoah\'s wife and told her she would conceive and bear a son who would be a Nazirite.',
              'bibleReference': 'Judges 13:3',
            },
            {
              'question': 'What vow was Samson set apart under from birth?',
              'options': ['The Levitical vow', 'The Nazirite vow', 'The Abrahamic covenant', 'The priestly vow'],
              'answer': 'The Nazirite vow',
              'explanation': 'Samson was to be a Nazirite, set apart to God from the womb. No razor was to touch his head.',
              'bibleReference': 'Judges 13:5',
            },
            {
              'question': 'What animal did Samson tear apart with his bare hands?',
              'options': ['A bear', 'A young lion', 'A wild ox', 'A wolf'],
              'answer': 'A young lion',
              'explanation': 'A young lion came roaring toward Samson, and the Spirit of the Lord came upon him so that he tore the lion apart with his bare hands.',
              'bibleReference': 'Judges 14:5-6',
            },
            {
              'question': 'What did Samson find inside the carcass of the lion when he returned to it?',
              'options': ['A serpent', 'A swarm of bees and honey', 'A bird\'s nest', 'Nothing remained'],
              'answer': 'A swarm of bees and honey',
              'explanation': 'When Samson later returned to the lion\'s carcass, he found a swarm of bees and honey inside it.',
              'bibleReference': 'Judges 14:8',
            },
            {
              'question': 'What was the answer to Samson\'s riddle about the lion?',
              'options': ['A lion and a lamb', 'Honey and a lion', 'The sun and the moon', 'A sword and a shield'],
              'answer': 'Honey and a lion',
              'explanation': 'The Philistines answered: "What is sweeter than honey? What is stronger than a lion?" revealing they had learned the answer from his wife.',
              'bibleReference': 'Judges 14:18',
            },
            {
              'question': 'How many foxes did Samson catch to burn the Philistines\' fields?',
              'options': ['One hundred', 'Two hundred', 'Three hundred', 'Four hundred'],
              'answer': 'Three hundred',
              'explanation': 'Samson caught three hundred foxes, tied them tail to tail with torches, and released them into the Philistine grain fields.',
              'bibleReference': 'Judges 15:4',
            },
            {
              'question': 'What weapon did Samson use to strike down a thousand Philistines?',
              'options': ['A sword', 'A spear', 'The jawbone of a donkey', 'A club'],
              'answer': 'The jawbone of a donkey',
              'explanation': 'Samson found a fresh jawbone of a donkey, seized it, and struck down a thousand men with it.',
              'bibleReference': 'Judges 15:15',
            },
            {
              'question': 'What was the name of Samson\'s father?',
              'options': ['Elkanah', 'Manoah', 'Kish', 'Jesse'],
              'answer': 'Manoah',
              'explanation': 'Samson\'s father was Manoah, from the clan of the Danites in the city of Zorah.',
              'bibleReference': 'Judges 13:2',
            },
            {
              'question': 'What miraculous thing happened after Samson defeated the thousand Philistines and became very thirsty?',
              'options': ['An angel brought him water', 'It rained from heaven', 'God opened a hollow place and water flowed out', 'A spring appeared beneath his feet'],
              'answer': 'God opened a hollow place and water flowed out',
              'explanation': 'Samson was very thirsty and cried out to the Lord. God opened a hollow place at Lehi, and water came out of it for Samson to drink.',
              'bibleReference': 'Judges 15:19',
            },
          ],
        },
        {
          'id': 'samson_and_delilah',
          'title': 'Samson and Delilah',
          'difficulty': 'Hard',
          'timerEnabled': false,
          'timerDurationSeconds': 30,
          'requiredCorrect': 6,
          'narratives': [
            {'text': 'Despite his great strength, Samson had a great weakness. He fell in love with a woman named Delilah in the Valley of Sorek. The Philistine rulers saw their opportunity and each offered Delilah eleven hundred pieces of silver to discover the secret of Samson\'s extraordinary power.', 'speaker': 'Narrator'},
            {'text': 'Day after day, Delilah pleaded with Samson to reveal his secret. Three times he deceived her with false answers. First he claimed fresh bowstrings would weaken him, then new ropes, and then that weaving his hair into a loom would rob his strength. Each time Delilah tested his words and found them to be lies.', 'speaker': 'Narrator'},
            {'text': 'Finally, worn down by her relentless nagging, Samson told Delilah the truth. No razor had ever touched his head because he was a Nazirite dedicated to God from birth. If his head were shaved, his strength would leave him. That night, Delilah lulled Samson to sleep on her lap and called for a man to shave off the seven braids of his hair.', 'speaker': 'Narrator'},
            {'text': 'When Samson awoke, he did not know that the Lord had departed from him. The Philistines seized him, gouged out his eyes, and bound him with bronze shackles in a prison at Gaza. But as time passed, his hair began to grow again. At a great feast to their god Dagon, the Philistines brought Samson out for entertainment. Samson prayed one final time, pushed against the two central pillars, and the temple collapsed, killing more Philistines in his death than in his entire life.', 'speaker': 'Narrator'},
          ],
          'questions': [
            {
              'question': 'In which valley did Delilah live?',
              'options': ['Valley of Elah', 'Valley of Sorek', 'Valley of Jezreel', 'Valley of Hinnom'],
              'answer': 'Valley of Sorek',
              'explanation': 'Samson fell in love with a woman in the Valley of Sorek, whose name was Delilah.',
              'bibleReference': 'Judges 16:4',
            },
            {
              'question': 'How much silver did each Philistine ruler offer Delilah to betray Samson?',
              'options': ['Five hundred pieces', 'Eleven hundred pieces', 'One thousand pieces', 'Three hundred pieces'],
              'answer': 'Eleven hundred pieces',
              'explanation': 'Each of the rulers of the Philistines offered Delilah eleven hundred pieces of silver to entice Samson and find the source of his great strength.',
              'bibleReference': 'Judges 16:5',
            },
            {
              'question': 'What was Samson\'s first false answer about the source of his strength?',
              'options': ['New ropes', 'Seven fresh bowstrings', 'Weaving his hair into a loom', 'A golden chain'],
              'answer': 'Seven fresh bowstrings',
              'explanation': 'Samson first told Delilah that if he were tied with seven fresh bowstrings that had not been dried, he would become as weak as any other man.',
              'bibleReference': 'Judges 16:7',
            },
            {
              'question': 'What was Samson\'s second false answer about losing his strength?',
              'options': ['Cutting his hair', 'Binding him with new ropes', 'Pouring water over him', 'Touching an unclean animal'],
              'answer': 'Binding him with new ropes',
              'explanation': 'Samson told Delilah that if he were bound with new ropes that had never been used, he would become weak.',
              'bibleReference': 'Judges 16:11',
            },
            {
              'question': 'What was the true secret of Samson\'s strength?',
              'options': ['A magic bracelet he wore', 'His hair had never been cut', 'He ate special food', 'He wore a sacred garment'],
              'answer': 'His hair had never been cut',
              'explanation': 'Samson told Delilah that no razor had ever been used on his head because he was a Nazirite dedicated to God from birth. If his head were shaved, his strength would leave him.',
              'bibleReference': 'Judges 16:17',
            },
            {
              'question': 'How many braids of hair did Samson have that were shaved off?',
              'options': ['Three', 'Five', 'Seven', 'Twelve'],
              'answer': 'Seven',
              'explanation': 'Delilah called for someone to shave off the seven braids of Samson\'s hair while he slept on her lap.',
              'bibleReference': 'Judges 16:19',
            },
            {
              'question': 'What did the Philistines do to Samson after capturing him?',
              'options': ['Put him in a cage', 'Gouged out his eyes', 'Cut off his hands', 'Branded his forehead'],
              'answer': 'Gouged out his eyes',
              'explanation': 'The Philistines seized Samson, gouged out his eyes, and took him down to Gaza where they bound him with bronze shackles.',
              'bibleReference': 'Judges 16:21',
            },
            {
              'question': 'What was the name of the false god whose temple Samson destroyed?',
              'options': ['Baal', 'Dagon', 'Molech', 'Ashtoreth'],
              'answer': 'Dagon',
              'explanation': 'The Philistine rulers assembled to offer a great sacrifice to Dagon their god and to celebrate Samson\'s capture.',
              'bibleReference': 'Judges 16:23',
            },
            {
              'question': 'How did Samson destroy the temple of the Philistines?',
              'options': ['He set it on fire', 'He pushed apart the two central pillars', 'He pulled down the roof', 'He broke through the walls'],
              'answer': 'He pushed apart the two central pillars',
              'explanation': 'Samson reached toward the two central pillars on which the temple stood, braced himself against them, and pushed with all his might, bringing the temple down.',
              'bibleReference': 'Judges 16:29-30',
            },
            {
              'question': 'How did Samson\'s final act compare to his lifetime achievements?',
              'options': ['It was less significant', 'He killed more Philistines in his death than in his life', 'It was equal to his other victories', 'He killed no one in his final act'],
              'answer': 'He killed more Philistines in his death than in his life',
              'explanation': 'Scripture records that Samson killed many more Philistines when he died than while he lived, as the temple was full of men and women and about three thousand on the roof.',
              'bibleReference': 'Judges 16:30',
            },
          ],
        },
      ],
    },
  ];
}
