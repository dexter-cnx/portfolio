const double kSectionRevealSlideFrom = 0.06;
const double kSectionHeaderSlideFrom = 0.08;
const double kContentRevealSlideFrom = 0.06;
const double kCardRevealSlideFrom = 0.08;
const double kHeroEyebrowSlideFrom = 0.15;
const double kHeroTextSlideFrom = 0.12;
const double kHeroDescriptionSlideFrom = 0.08;
const double kHeroCtaSlideFrom = 0.10;
const double kExperienceDetailSlideFrom = 0.04;
const double kContactRowSlideFrom = 0.05;

const Duration kHeroImageDelay = Duration(milliseconds: 240);
const Duration kHeroEyebrowDelay = Duration(milliseconds: 80);
const Duration kHeroHeadlineDelay = Duration(milliseconds: 160);
const Duration kHeroSubheadlineDelay = Duration(milliseconds: 240);
const Duration kHeroDescriptionDelay = Duration(milliseconds: 320);
const Duration kHeroPrimaryCtaDelay = Duration(milliseconds: 440);
const Duration kHeroSecondaryCtaDelay = Duration(milliseconds: 520);
const Duration kHeroPromptDelay = Duration(milliseconds: 680);

const Duration kAboutProfileDelay = Duration(milliseconds: 240);
const Duration kAboutParagraphStagger = Duration(milliseconds: 80);
const Duration kAboutSkillsHeaderDelay = Duration(milliseconds: 120);
const Duration kAboutSkillChipStagger = Duration(milliseconds: 60);

const Duration kProjectFeaturedCardStagger = Duration(milliseconds: 120);
const Duration kProjectImageDelay = Duration(milliseconds: 120);
const Duration kProjectContentLeadDelay = Duration(milliseconds: 120);
const Duration kProjectContentStep = Duration(milliseconds: 80);
const Duration kProjectOtherCardStagger = Duration(milliseconds: 80);

const Duration kContactIntroStagger = Duration(milliseconds: 80);
const Duration kContactRowStagger = Duration(milliseconds: 80);
const Duration kContactSocialBaseDelay = Duration(milliseconds: 520);
const Duration kContactSocialStagger = Duration(milliseconds: 80);

Duration staggeredDelay(
  int index, {
  Duration base = Duration.zero,
  Duration step = const Duration(milliseconds: 80),
}) {
  return base + (step * index);
}
