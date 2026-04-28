// class ThemeModel {
//   TypographyArabic? typographyArabic;
//   TypographyArabic? typographyEnglish;
//   ColorsSystemLight? colorsSystemLight;
//   ColorsSystemLight? colorsSystemDark;
//   NumericTokensMode1? numericTokensMode1;

//   ThemeModel({
//     this.typographyArabic,
//     this.typographyEnglish,
//     this.colorsSystemLight,
//     this.colorsSystemDark,
//     this.numericTokensMode1,
//   });

//   ThemeModel.fromJson(Map<String, dynamic> json) {
//     typographyArabic = json['typography-arabic'] != null
//         ? new TypographyArabic.fromJson(json['typography-arabic'])
//         : null;
//     typographyEnglish = json['typography-english'] != null
//         ? new TypographyArabic.fromJson(json['typography-english'])
//         : null;
//     colorsSystemLight = json['colors-system-light'] != null
//         ? new ColorsSystemLight.fromJson(json['colors-system-light'])
//         : null;
//     colorsSystemDark = json['colors-system-dark'] != null
//         ? new ColorsSystemLight.fromJson(json['colors-system-dark'])
//         : null;
//     numericTokensMode1 = json['numeric-tokens-mode 1'] != null
//         ? new NumericTokensMode1.fromJson(json['numeric-tokens-mode 1'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.typographyArabic != null) {
//       data['typography-arabic'] = this.typographyArabic!.toJson();
//     }
//     if (this.typographyEnglish != null) {
//       data['typography-english'] = this.typographyEnglish!.toJson();
//     }
//     if (this.colorsSystemLight != null) {
//       data['colors-system-light'] = this.colorsSystemLight!.toJson();
//     }
//     if (this.colorsSystemDark != null) {
//       data['colors-system-dark'] = this.colorsSystemDark!.toJson();
//     }
//     if (this.numericTokensMode1 != null) {
//       data['numeric-tokens-mode 1'] = this.numericTokensMode1!.toJson();
//     }
//     return data;
//   }
// }

// class TypographyArabic {
//   Typeface? typeface;

//   TypographyArabic({this.typeface});

//   TypographyArabic.fromJson(Map<String, dynamic> json) {
//     typeface = json['Typeface'] != null
//         ? new Typeface.fromJson(json['Typeface'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.typeface != null) {
//       data['Typeface'] = this.typeface!.toJson();
//     }
//     return data;
//   }
// }

// class Typeface {
//   Family? family;
//   Weight? weight;
//   Size? size;

//   Typeface({this.family, this.weight, this.size});

//   Typeface.fromJson(Map<String, dynamic> json) {
//     family = json['Family'] != null
//         ? new Family.fromJson(json['Family'])
//         : null;
//     weight = json['Weight'] != null
//         ? new Weight.fromJson(json['Weight'])
//         : null;
//     size = json['Size'] != null ? new Size.fromJson(json['Size']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.family != null) {
//       data['Family'] = this.family!.toJson();
//     }
//     if (this.weight != null) {
//       data['Weight'] = this.weight!.toJson();
//     }
//     if (this.size != null) {
//       data['Size'] = this.size!.toJson();
//     }
//     return data;
//   }
// }

// class Family {
//   Display? display;
//   Display? text;

//   Family({this.display, this.text});

//   Family.fromJson(Map<String, dynamic> json) {
//     display = json['Display'] != null
//         ? new Display.fromJson(json['Display'])
//         : null;
//     text = json['Text'] != null ? new Display.fromJson(json['Text']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.display != null) {
//       data['Display'] = this.display!.toJson();
//     }
//     if (this.text != null) {
//       data['Text'] = this.text!.toJson();
//     }
//     return data;
//   }
// }

// class Display {
//   String? value;
//   String? type;
//   List<String>? scope;
//   Extensions? extensions;

//   Display({this.value, this.type, this.scope, this.extensions});

//   Display.fromJson(Map<String, dynamic> json) {
//     value = json['value'];
//     type = json['type'];
//     scope = json['scope'].cast<String>();
//     extensions = json['$extensions'] != null
//         ? new Extensions.fromJson(json['$extensions'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['value'] = this.value;
//     data['type'] = this.type;
//     data['scope'] = this.scope;
//     if (this.extensions != null) {
//       data['$extensions'] = this.extensions!.toJson();
//     }
//     return data;
//   }
// }

// class Extensions {
//   TokensStudio? tokensStudio;

//   Extensions({this.tokensStudio});

//   Extensions.fromJson(Map<String, dynamic> json) {
//     tokensStudio = json['tokens-studio'] != null
//         ? new TokensStudio.fromJson(json['tokens-studio'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.tokensStudio != null) {
//       data['tokens-studio'] = this.tokensStudio!.toJson();
//     }
//     return data;
//   }
// }

// class TokensStudio {
//   String? mode;

//   TokensStudio({this.mode});

//   TokensStudio.fromJson(Map<String, dynamic> json) {
//     mode = json['mode'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['mode'] = this.mode;
//     return data;
//   }
// }

// class Weight {
//   Display? regular;
//   Display? medium;
//   Display? semibold;
//   Display? bold;

//   Weight({this.regular, this.medium, this.semibold, this.bold});

//   Weight.fromJson(Map<String, dynamic> json) {
//     regular = json['Regular'] != null
//         ? new Display.fromJson(json['Regular'])
//         : null;
//     medium = json['Medium'] != null
//         ? new Display.fromJson(json['Medium'])
//         : null;
//     semibold = json['Semibold'] != null
//         ? new Display.fromJson(json['Semibold'])
//         : null;
//     bold = json['Bold'] != null ? new Display.fromJson(json['Bold']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.regular != null) {
//       data['Regular'] = this.regular!.toJson();
//     }
//     if (this.medium != null) {
//       data['Medium'] = this.medium!.toJson();
//     }
//     if (this.semibold != null) {
//       data['Semibold'] = this.semibold!.toJson();
//     }
//     if (this.bold != null) {
//       data['Bold'] = this.bold!.toJson();
//     }
//     return data;
//   }
// }

// class Size {
//   Display? sM;
//   Display? mD;
//   Display? lG;
//   Display? xL;
//   Display? d2XL;
//   Display? d3XL;
//   Display? d4XL;
//   Display? d5XL;
//   Display? d6XL;
//   Display? d7XL;

//   Size({
//     this.sM,
//     this.mD,
//     this.lG,
//     this.xL,
//     this.d2XL,
//     this.d3XL,
//     this.d4XL,
//     this.d5XL,
//     this.d6XL,
//     this.d7XL,
//   });

//   Size.fromJson(Map<String, dynamic> json) {
//     sM = json['SM'] != null ? new Display.fromJson(json['SM']) : null;
//     mD = json['MD'] != null ? new Display.fromJson(json['MD']) : null;
//     lG = json['LG'] != null ? new Display.fromJson(json['LG']) : null;
//     xL = json['XL'] != null ? new Display.fromJson(json['XL']) : null;
//     d2XL = json['2XL'] != null ? new Display.fromJson(json['2XL']) : null;
//     d3XL = json['3XL'] != null ? new Display.fromJson(json['3XL']) : null;
//     d4XL = json['4XL'] != null ? new Display.fromJson(json['4XL']) : null;
//     d5XL = json['5XL'] != null ? new Display.fromJson(json['5XL']) : null;
//     d6XL = json['6XL'] != null ? new Display.fromJson(json['6XL']) : null;
//     d7XL = json['7XL'] != null ? new Display.fromJson(json['7XL']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.sM != null) {
//       data['SM'] = this.sM!.toJson();
//     }
//     if (this.mD != null) {
//       data['MD'] = this.mD!.toJson();
//     }
//     if (this.lG != null) {
//       data['LG'] = this.lG!.toJson();
//     }
//     if (this.xL != null) {
//       data['XL'] = this.xL!.toJson();
//     }
//     if (this.d2XL != null) {
//       data['2XL'] = this.d2XL!.toJson();
//     }
//     if (this.d3XL != null) {
//       data['3XL'] = this.d3XL!.toJson();
//     }
//     if (this.d4XL != null) {
//       data['4XL'] = this.d4XL!.toJson();
//     }
//     if (this.d5XL != null) {
//       data['5XL'] = this.d5XL!.toJson();
//     }
//     if (this.d6XL != null) {
//       data['6XL'] = this.d6XL!.toJson();
//     }
//     if (this.d7XL != null) {
//       data['7XL'] = this.d7XL!.toJson();
//     }
//     return data;
//   }
// }

// class ColorsSystemLight {
//   PrimarySecondary? primarySecondary;
//   Backgrounds? backgrounds;
//   Cards? cards;
//   TextSystem? textSystem;
//   Buttons? buttons;
//   NeutralsWhite? neutralsWhite;
//   StatusColors? statusColors;
//   Icon? icon;

//   ColorsSystemLight({
//     this.primarySecondary,
//     this.backgrounds,
//     this.cards,
//     this.textSystem,
//     this.buttons,
//     this.neutralsWhite,
//     this.statusColors,
//     this.icon,
//   });

//   ColorsSystemLight.fromJson(Map<String, dynamic> json) {
//     primarySecondary = json['Primary & Secondary'] != null
//         ? new PrimarySecondary.fromJson(json['Primary & Secondary'])
//         : null;
//     backgrounds = json['Backgrounds'] != null
//         ? new Backgrounds.fromJson(json['Backgrounds'])
//         : null;
//     cards = json['Cards'] != null ? new Cards.fromJson(json['Cards']) : null;
//     textSystem = json['Text System'] != null
//         ? new TextSystem.fromJson(json['Text System'])
//         : null;
//     buttons = json['Buttons'] != null
//         ? new Buttons.fromJson(json['Buttons'])
//         : null;
//     neutralsWhite = json['Neutrals & White'] != null
//         ? new NeutralsWhite.fromJson(json['Neutrals & White'])
//         : null;
//     statusColors = json['Status Colors'] != null
//         ? new StatusColors.fromJson(json['Status Colors'])
//         : null;
//     icon = json['Icon'] != null ? new Icon.fromJson(json['Icon']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.primarySecondary != null) {
//       data['Primary & Secondary'] = this.primarySecondary!.toJson();
//     }
//     if (this.backgrounds != null) {
//       data['Backgrounds'] = this.backgrounds!.toJson();
//     }
//     if (this.cards != null) {
//       data['Cards'] = this.cards!.toJson();
//     }
//     if (this.textSystem != null) {
//       data['Text System'] = this.textSystem!.toJson();
//     }
//     if (this.buttons != null) {
//       data['Buttons'] = this.buttons!.toJson();
//     }
//     if (this.neutralsWhite != null) {
//       data['Neutrals & White'] = this.neutralsWhite!.toJson();
//     }
//     if (this.statusColors != null) {
//       data['Status Colors'] = this.statusColors!.toJson();
//     }
//     if (this.icon != null) {
//       data['Icon'] = this.icon!.toJson();
//     }
//     return data;
//   }
// }

// class PrimarySecondary {
//   Display? colorPrimaryDefault;
//   Display? colorPrimary50;
//   Display? colorPrimary100;
//   Display? colorPrimary200;
//   Display? colorPrimary300;
//   Display? colorPrimary400;
//   Display? colorPrimary500;
//   Display? colorPrimary600;
//   Display? colorPrimary700;
//   Display? colorPrimary800;
//   Display? colorPrimary900;
//   Display? colorSecondaryDefault;
//   Display? colorSecondary50;
//   Display? colorSecondary100;
//   Display? colorSecondary200;
//   Display? colorSecondary300;
//   Display? colorSecondary400;
//   Display? colorSecondary500;
//   Display? colorSecondary600;
//   Display? colorSecondary700;
//   Display? colorSecondary800;
//   Display? colorSecondary900;

//   PrimarySecondary({
//     this.colorPrimaryDefault,
//     this.colorPrimary50,
//     this.colorPrimary100,
//     this.colorPrimary200,
//     this.colorPrimary300,
//     this.colorPrimary400,
//     this.colorPrimary500,
//     this.colorPrimary600,
//     this.colorPrimary700,
//     this.colorPrimary800,
//     this.colorPrimary900,
//     this.colorSecondaryDefault,
//     this.colorSecondary50,
//     this.colorSecondary100,
//     this.colorSecondary200,
//     this.colorSecondary300,
//     this.colorSecondary400,
//     this.colorSecondary500,
//     this.colorSecondary600,
//     this.colorSecondary700,
//     this.colorSecondary800,
//     this.colorSecondary900,
//   });

//   PrimarySecondary.fromJson(Map<String, dynamic> json) {
//     colorPrimaryDefault = json['color-primary-default'] != null
//         ? new Display.fromJson(json['color-primary-default'])
//         : null;
//     colorPrimary50 = json['color-primary-50'] != null
//         ? new Display.fromJson(json['color-primary-50'])
//         : null;
//     colorPrimary100 = json['color-primary-100'] != null
//         ? new Display.fromJson(json['color-primary-100'])
//         : null;
//     colorPrimary200 = json['color-primary-200'] != null
//         ? new Display.fromJson(json['color-primary-200'])
//         : null;
//     colorPrimary300 = json['color-primary-300'] != null
//         ? new Display.fromJson(json['color-primary-300'])
//         : null;
//     colorPrimary400 = json['color-primary-400'] != null
//         ? new Display.fromJson(json['color-primary-400'])
//         : null;
//     colorPrimary500 = json['color-primary-500'] != null
//         ? new Display.fromJson(json['color-primary-500'])
//         : null;
//     colorPrimary600 = json['color-primary-600'] != null
//         ? new Display.fromJson(json['color-primary-600'])
//         : null;
//     colorPrimary700 = json['color-primary-700'] != null
//         ? new Display.fromJson(json['color-primary-700'])
//         : null;
//     colorPrimary800 = json['color-primary-800'] != null
//         ? new Display.fromJson(json['color-primary-800'])
//         : null;
//     colorPrimary900 = json['color-primary-900'] != null
//         ? new Display.fromJson(json['color-primary-900'])
//         : null;
//     colorSecondaryDefault = json['color-secondary-default'] != null
//         ? new Display.fromJson(json['color-secondary-default'])
//         : null;
//     colorSecondary50 = json['color-secondary-50'] != null
//         ? new Display.fromJson(json['color-secondary-50'])
//         : null;
//     colorSecondary100 = json['color-secondary-100'] != null
//         ? new Display.fromJson(json['color-secondary-100'])
//         : null;
//     colorSecondary200 = json['color-secondary-200'] != null
//         ? new Display.fromJson(json['color-secondary-200'])
//         : null;
//     colorSecondary300 = json['color-secondary-300'] != null
//         ? new Display.fromJson(json['color-secondary-300'])
//         : null;
//     colorSecondary400 = json['color-secondary-400'] != null
//         ? new Display.fromJson(json['color-secondary-400'])
//         : null;
//     colorSecondary500 = json['color-secondary-500'] != null
//         ? new Display.fromJson(json['color-secondary-500'])
//         : null;
//     colorSecondary600 = json['color-secondary-600'] != null
//         ? new Display.fromJson(json['color-secondary-600'])
//         : null;
//     colorSecondary700 = json['color-secondary-700'] != null
//         ? new Display.fromJson(json['color-secondary-700'])
//         : null;
//     colorSecondary800 = json['color-secondary-800'] != null
//         ? new Display.fromJson(json['color-secondary-800'])
//         : null;
//     colorSecondary900 = json['color-secondary-900'] != null
//         ? new Display.fromJson(json['color-secondary-900'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.colorPrimaryDefault != null) {
//       data['color-primary-default'] = this.colorPrimaryDefault!.toJson();
//     }
//     if (this.colorPrimary50 != null) {
//       data['color-primary-50'] = this.colorPrimary50!.toJson();
//     }
//     if (this.colorPrimary100 != null) {
//       data['color-primary-100'] = this.colorPrimary100!.toJson();
//     }
//     if (this.colorPrimary200 != null) {
//       data['color-primary-200'] = this.colorPrimary200!.toJson();
//     }
//     if (this.colorPrimary300 != null) {
//       data['color-primary-300'] = this.colorPrimary300!.toJson();
//     }
//     if (this.colorPrimary400 != null) {
//       data['color-primary-400'] = this.colorPrimary400!.toJson();
//     }
//     if (this.colorPrimary500 != null) {
//       data['color-primary-500'] = this.colorPrimary500!.toJson();
//     }
//     if (this.colorPrimary600 != null) {
//       data['color-primary-600'] = this.colorPrimary600!.toJson();
//     }
//     if (this.colorPrimary700 != null) {
//       data['color-primary-700'] = this.colorPrimary700!.toJson();
//     }
//     if (this.colorPrimary800 != null) {
//       data['color-primary-800'] = this.colorPrimary800!.toJson();
//     }
//     if (this.colorPrimary900 != null) {
//       data['color-primary-900'] = this.colorPrimary900!.toJson();
//     }
//     if (this.colorSecondaryDefault != null) {
//       data['color-secondary-default'] = this.colorSecondaryDefault!.toJson();
//     }
//     if (this.colorSecondary50 != null) {
//       data['color-secondary-50'] = this.colorSecondary50!.toJson();
//     }
//     if (this.colorSecondary100 != null) {
//       data['color-secondary-100'] = this.colorSecondary100!.toJson();
//     }
//     if (this.colorSecondary200 != null) {
//       data['color-secondary-200'] = this.colorSecondary200!.toJson();
//     }
//     if (this.colorSecondary300 != null) {
//       data['color-secondary-300'] = this.colorSecondary300!.toJson();
//     }
//     if (this.colorSecondary400 != null) {
//       data['color-secondary-400'] = this.colorSecondary400!.toJson();
//     }
//     if (this.colorSecondary500 != null) {
//       data['color-secondary-500'] = this.colorSecondary500!.toJson();
//     }
//     if (this.colorSecondary600 != null) {
//       data['color-secondary-600'] = this.colorSecondary600!.toJson();
//     }
//     if (this.colorSecondary700 != null) {
//       data['color-secondary-700'] = this.colorSecondary700!.toJson();
//     }
//     if (this.colorSecondary800 != null) {
//       data['color-secondary-800'] = this.colorSecondary800!.toJson();
//     }
//     if (this.colorSecondary900 != null) {
//       data['color-secondary-900'] = this.colorSecondary900!.toJson();
//     }
//     return data;
//   }
// }

// class Backgrounds {
//   Display? bgSurfaceDefault;
//   Display? bgSurfaceSubtle;

//   Backgrounds({this.bgSurfaceDefault, this.bgSurfaceSubtle});

//   Backgrounds.fromJson(Map<String, dynamic> json) {
//     bgSurfaceDefault = json['bg-surface-default'] != null
//         ? new Display.fromJson(json['bg-surface-default'])
//         : null;
//     bgSurfaceSubtle = json['bg-surface-subtle'] != null
//         ? new Display.fromJson(json['bg-surface-subtle'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.bgSurfaceDefault != null) {
//       data['bg-surface-default'] = this.bgSurfaceDefault!.toJson();
//     }
//     if (this.bgSurfaceSubtle != null) {
//       data['bg-surface-subtle'] = this.bgSurfaceSubtle!.toJson();
//     }
//     return data;
//   }
// }

// class Cards {
//   Display? bgCardDefault;
//   Display? borderCardDefault;

//   Cards({this.bgCardDefault, this.borderCardDefault});

//   Cards.fromJson(Map<String, dynamic> json) {
//     bgCardDefault = json['bg-card-default'] != null
//         ? new Display.fromJson(json['bg-card-default'])
//         : null;
//     borderCardDefault = json['border-card-default'] != null
//         ? new Display.fromJson(json['border-card-default'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.bgCardDefault != null) {
//       data['bg-card-default'] = this.bgCardDefault!.toJson();
//     }
//     if (this.borderCardDefault != null) {
//       data['border-card-default'] = this.borderCardDefault!.toJson();
//     }
//     return data;
//   }
// }

// class TextSystem {
//   Display? textHeading;
//   Display? textBody;
//   Display? textDisplay;
//   Display? textButton;
//   Display? textButtonDisabled;
//   Display? textButtonOutlined;

//   TextSystem({
//     this.textHeading,
//     this.textBody,
//     this.textDisplay,
//     this.textButton,
//     this.textButtonDisabled,
//     this.textButtonOutlined,
//   });

//   TextSystem.fromJson(Map<String, dynamic> json) {
//     textHeading = json['text-heading'] != null
//         ? new Display.fromJson(json['text-heading'])
//         : null;
//     textBody = json['text-body'] != null
//         ? new Display.fromJson(json['text-body'])
//         : null;
//     textDisplay = json['text-display'] != null
//         ? new Display.fromJson(json['text-display'])
//         : null;
//     textButton = json['text-button'] != null
//         ? new Display.fromJson(json['text-button'])
//         : null;
//     textButtonDisabled = json['text-button-disabled'] != null
//         ? new Display.fromJson(json['text-button-disabled'])
//         : null;
//     textButtonOutlined = json['text-button-outlined'] != null
//         ? new Display.fromJson(json['text-button-outlined'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.textHeading != null) {
//       data['text-heading'] = this.textHeading!.toJson();
//     }
//     if (this.textBody != null) {
//       data['text-body'] = this.textBody!.toJson();
//     }
//     if (this.textDisplay != null) {
//       data['text-display'] = this.textDisplay!.toJson();
//     }
//     if (this.textButton != null) {
//       data['text-button'] = this.textButton!.toJson();
//     }
//     if (this.textButtonDisabled != null) {
//       data['text-button-disabled'] = this.textButtonDisabled!.toJson();
//     }
//     if (this.textButtonOutlined != null) {
//       data['text-button-outlined'] = this.textButtonOutlined!.toJson();
//     }
//     return data;
//   }
// }

// class Buttons {
//   Display? bgButtonPrimaryDefault2;
//   Display? bgButtonPrimaryHover;
//   Display? bgButtonPrimaryDisabled;
//   Display? borderButtonPrimary;
//   Display? borderButtonOutlined;

//   Buttons({
//     this.bgButtonPrimaryDefault2,
//     this.bgButtonPrimaryHover,
//     this.bgButtonPrimaryDisabled,
//     this.borderButtonPrimary,
//     this.borderButtonOutlined,
//   });

//   Buttons.fromJson(Map<String, dynamic> json) {
//     bgButtonPrimaryDefault2 = json['bg-button-primary-default 2'] != null
//         ? new Display.fromJson(json['bg-button-primary-default 2'])
//         : null;
//     bgButtonPrimaryHover = json['bg-button-primary-hover'] != null
//         ? new Display.fromJson(json['bg-button-primary-hover'])
//         : null;
//     bgButtonPrimaryDisabled = json['bg-button-primary-disabled'] != null
//         ? new Display.fromJson(json['bg-button-primary-disabled'])
//         : null;
//     borderButtonPrimary = json['border-button-primary'] != null
//         ? new Display.fromJson(json['border-button-primary'])
//         : null;
//     borderButtonOutlined = json['border-button-outlined'] != null
//         ? new Display.fromJson(json['border-button-outlined'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.bgButtonPrimaryDefault2 != null) {
//       data['bg-button-primary-default 2'] = this.bgButtonPrimaryDefault2!
//           .toJson();
//     }
//     if (this.bgButtonPrimaryHover != null) {
//       data['bg-button-primary-hover'] = this.bgButtonPrimaryHover!.toJson();
//     }
//     if (this.bgButtonPrimaryDisabled != null) {
//       data['bg-button-primary-disabled'] = this.bgButtonPrimaryDisabled!
//           .toJson();
//     }
//     if (this.borderButtonPrimary != null) {
//       data['border-button-primary'] = this.borderButtonPrimary!.toJson();
//     }
//     if (this.borderButtonOutlined != null) {
//       data['border-button-outlined'] = this.borderButtonOutlined!.toJson();
//     }
//     return data;
//   }
// }

// class NeutralsWhite {
//   Display? colorWhite;

//   NeutralsWhite({this.colorWhite});

//   NeutralsWhite.fromJson(Map<String, dynamic> json) {
//     colorWhite = json['color-white'] != null
//         ? new Display.fromJson(json['color-white'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.colorWhite != null) {
//       data['color-white'] = this.colorWhite!.toJson();
//     }
//     return data;
//   }
// }

// class StatusColors {
//   Display? colorErrorDefault;
//   Display? bgErrorSubtle;
//   Display? colorWarningDefault;
//   Display? bgWarningSubtle;
//   Display? colorSuccessDefault;
//   Display? bgSuccessSubtle;

//   StatusColors({
//     this.colorErrorDefault,
//     this.bgErrorSubtle,
//     this.colorWarningDefault,
//     this.bgWarningSubtle,
//     this.colorSuccessDefault,
//     this.bgSuccessSubtle,
//   });

//   StatusColors.fromJson(Map<String, dynamic> json) {
//     colorErrorDefault = json['color-error-default'] != null
//         ? new Display.fromJson(json['color-error-default'])
//         : null;
//     bgErrorSubtle = json['bg-error-subtle'] != null
//         ? new Display.fromJson(json['bg-error-subtle'])
//         : null;
//     colorWarningDefault = json['color-warning-default'] != null
//         ? new Display.fromJson(json['color-warning-default'])
//         : null;
//     bgWarningSubtle = json['bg-warning-subtle'] != null
//         ? new Display.fromJson(json['bg-warning-subtle'])
//         : null;
//     colorSuccessDefault = json['color-success-default'] != null
//         ? new Display.fromJson(json['color-success-default'])
//         : null;
//     bgSuccessSubtle = json['bg-success-subtle'] != null
//         ? new Display.fromJson(json['bg-success-subtle'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.colorErrorDefault != null) {
//       data['color-error-default'] = this.colorErrorDefault!.toJson();
//     }
//     if (this.bgErrorSubtle != null) {
//       data['bg-error-subtle'] = this.bgErrorSubtle!.toJson();
//     }
//     if (this.colorWarningDefault != null) {
//       data['color-warning-default'] = this.colorWarningDefault!.toJson();
//     }
//     if (this.bgWarningSubtle != null) {
//       data['bg-warning-subtle'] = this.bgWarningSubtle!.toJson();
//     }
//     if (this.colorSuccessDefault != null) {
//       data['color-success-default'] = this.colorSuccessDefault!.toJson();
//     }
//     if (this.bgSuccessSubtle != null) {
//       data['bg-success-subtle'] = this.bgSuccessSubtle!.toJson();
//     }
//     return data;
//   }
// }

// class Icon {
//   Display? colorIconOnLight;
//   Display? colorIconOnDark;

//   Icon({this.colorIconOnLight, this.colorIconOnDark});

//   Icon.fromJson(Map<String, dynamic> json) {
//     colorIconOnLight = json['color-icon-onLight'] != null
//         ? new Display.fromJson(json['color-icon-onLight'])
//         : null;
//     colorIconOnDark = json['color-icon-onDark'] != null
//         ? new Display.fromJson(json['color-icon-onDark'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.colorIconOnLight != null) {
//       data['color-icon-onLight'] = this.colorIconOnLight!.toJson();
//     }
//     if (this.colorIconOnDark != null) {
//       data['color-icon-onDark'] = this.colorIconOnDark!.toJson();
//     }
//     return data;
//   }
// }

// class NumericTokensMode1 {
//   CornerRadiusSystem? cornerRadiusSystem;
//   Stroke? stroke;
//   Spacing? spacing;

//   NumericTokensMode1({this.cornerRadiusSystem, this.stroke, this.spacing});

//   NumericTokensMode1.fromJson(Map<String, dynamic> json) {
//     cornerRadiusSystem = json['corner radius system'] != null
//         ? new CornerRadiusSystem.fromJson(json['corner radius system'])
//         : null;
//     stroke = json['stroke'] != null
//         ? new Stroke.fromJson(json['stroke'])
//         : null;
//     spacing = json['spacing'] != null
//         ? new Spacing.fromJson(json['spacing'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.cornerRadiusSystem != null) {
//       data['corner radius system'] = this.cornerRadiusSystem!.toJson();
//     }
//     if (this.stroke != null) {
//       data['stroke'] = this.stroke!.toJson();
//     }
//     if (this.spacing != null) {
//       data['spacing'] = this.spacing!.toJson();
//     }
//     return data;
//   }
// }

// class CornerRadiusSystem {
//   Display? radiusXs;
//   Display? radiusSm;
//   Display? radiusMd;
//   Display? radiusLg;
//   Display? radiusXl;
//   Display? radiusFull;

//   CornerRadiusSystem({
//     this.radiusXs,
//     this.radiusSm,
//     this.radiusMd,
//     this.radiusLg,
//     this.radiusXl,
//     this.radiusFull,
//   });

//   CornerRadiusSystem.fromJson(Map<String, dynamic> json) {
//     radiusXs = json['radius-xs'] != null
//         ? new Display.fromJson(json['radius-xs'])
//         : null;
//     radiusSm = json['radius-sm'] != null
//         ? new Display.fromJson(json['radius-sm'])
//         : null;
//     radiusMd = json['radius-md'] != null
//         ? new Display.fromJson(json['radius-md'])
//         : null;
//     radiusLg = json['radius-lg'] != null
//         ? new Display.fromJson(json['radius-lg'])
//         : null;
//     radiusXl = json['radius-xl'] != null
//         ? new Display.fromJson(json['radius-xl'])
//         : null;
//     radiusFull = json['radius-full'] != null
//         ? new Display.fromJson(json['radius-full'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.radiusXs != null) {
//       data['radius-xs'] = this.radiusXs!.toJson();
//     }
//     if (this.radiusSm != null) {
//       data['radius-sm'] = this.radiusSm!.toJson();
//     }
//     if (this.radiusMd != null) {
//       data['radius-md'] = this.radiusMd!.toJson();
//     }
//     if (this.radiusLg != null) {
//       data['radius-lg'] = this.radiusLg!.toJson();
//     }
//     if (this.radiusXl != null) {
//       data['radius-xl'] = this.radiusXl!.toJson();
//     }
//     if (this.radiusFull != null) {
//       data['radius-full'] = this.radiusFull!.toJson();
//     }
//     return data;
//   }
// }

// class Stroke {
//   Display? strokeThin;
//   Display? strokeRegular;
//   Display? strokeBold;

//   Stroke({this.strokeThin, this.strokeRegular, this.strokeBold});

//   Stroke.fromJson(Map<String, dynamic> json) {
//     strokeThin = json['stroke-thin'] != null
//         ? new Display.fromJson(json['stroke-thin'])
//         : null;
//     strokeRegular = json['stroke-regular'] != null
//         ? new Display.fromJson(json['stroke-regular'])
//         : null;
//     strokeBold = json['stroke-bold'] != null
//         ? new Display.fromJson(json['stroke-bold'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.strokeThin != null) {
//       data['stroke-thin'] = this.strokeThin!.toJson();
//     }
//     if (this.strokeRegular != null) {
//       data['stroke-regular'] = this.strokeRegular!.toJson();
//     }
//     if (this.strokeBold != null) {
//       data['stroke-bold'] = this.strokeBold!.toJson();
//     }
//     return data;
//   }
// }

// class Spacing {
//   Display? space2xs;
//   Display? spaceXs;
//   Display? spaceSm;
//   Display? spaceMd;
//   Display? spaceLg;
//   Display? spaceXl;
//   Display? space2xl;
//   Display? space3xl;

//   Spacing({
//     this.space2xs,
//     this.spaceXs,
//     this.spaceSm,
//     this.spaceMd,
//     this.spaceLg,
//     this.spaceXl,
//     this.space2xl,
//     this.space3xl,
//   });

//   Spacing.fromJson(Map<String, dynamic> json) {
//     space2xs = json['space-2xs'] != null
//         ? new Display.fromJson(json['space-2xs'])
//         : null;
//     spaceXs = json['space-xs'] != null
//         ? new Display.fromJson(json['space-xs'])
//         : null;
//     spaceSm = json['space-sm'] != null
//         ? new Display.fromJson(json['space-sm'])
//         : null;
//     spaceMd = json['space-md'] != null
//         ? new Display.fromJson(json['space-md'])
//         : null;
//     spaceLg = json['space-lg'] != null
//         ? new Display.fromJson(json['space-lg'])
//         : null;
//     spaceXl = json['space-xl'] != null
//         ? new Display.fromJson(json['space-xl'])
//         : null;
//     space2xl = json['space-2xl'] != null
//         ? new Display.fromJson(json['space-2xl'])
//         : null;
//     space3xl = json['space-3xl'] != null
//         ? new Display.fromJson(json['space-3xl'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.space2xs != null) {
//       data['space-2xs'] = this.space2xs!.toJson();
//     }
//     if (this.spaceXs != null) {
//       data['space-xs'] = this.spaceXs!.toJson();
//     }
//     if (this.spaceSm != null) {
//       data['space-sm'] = this.spaceSm!.toJson();
//     }
//     if (this.spaceMd != null) {
//       data['space-md'] = this.spaceMd!.toJson();
//     }
//     if (this.spaceLg != null) {
//       data['space-lg'] = this.spaceLg!.toJson();
//     }
//     if (this.spaceXl != null) {
//       data['space-xl'] = this.spaceXl!.toJson();
//     }
//     if (this.space2xl != null) {
//       data['space-2xl'] = this.space2xl!.toJson();
//     }
//     if (this.space3xl != null) {
//       data['space-3xl'] = this.space3xl!.toJson();
//     }
//     return data;
//   }
// }
