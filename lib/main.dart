import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

const _ink = Color(0xFF17242C);
const _muted = Color(0xFF718087);
const _paper = Color(0xFFF6F5F1);
const _green = Color(0xFF176B58);
const _line = Color(0xFFE7E8E3);

void main() {
  runApp(const CvApp());
}

class CvApp extends StatefulWidget {
  const CvApp({super.key});

  @override
  State<CvApp> createState() => _CvAppState();
}

class _CvAppState extends State<CvApp> {
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(seedColor: _green, surface: _paper),
        fontFamily: 'Roboto',
      ),
      home: _isSignedIn
          ? PortfolioShell(onSignOut: () => setState(() => _isSignedIn = false))
          : LoginPage(onSignIn: () => setState(() => _isSignedIn = true)),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({required this.onSignIn, super.key});

  final VoidCallback onSignIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String? _loginError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;

    if (_usernameController.text.trim() != 'demo' ||
        _passwordController.text != 'demo123') {
      setState(() => _loginError = 'Identifiant ou mot de passe incorrect.');
      return;
    }

    widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: _green,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Colors.white,
                        size: 29,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'BONJOUR, BIENVENUE',
                      style: TextStyle(
                        color: _green,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Mon espace\nprofessionnel.',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 36,
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Connectez-vous pour découvrir mon parcours et mon univers.',
                      style: TextStyle(
                        color: _muted,
                        height: 1.5,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 34),
                    TextFormField(
                      key: const Key('usernameField'),
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        label: 'Identifiant',
                        icon: Icons.alternate_email_rounded,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Saisissez votre identifiant.'
                          : null,
                      onChanged: (_) => setState(() => _loginError = null),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('passwordField'),
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _signIn(),
                      decoration:
                          _inputDecoration(
                            label: 'Mot de passe',
                            icon: Icons.lock_outline_rounded,
                          ).copyWith(
                            suffixIcon: IconButton(
                              tooltip: _passwordVisible
                                  ? 'Masquer le mot de passe'
                                  : 'Afficher le mot de passe',
                              onPressed: () => setState(
                                () => _passwordVisible = !_passwordVisible,
                              ),
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Saisissez votre mot de passe.'
                          : null,
                      onChanged: (_) => setState(() => _loginError = null),
                    ),
                    if (_loginError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _loginError!,
                        key: const Key('loginError'),
                        style: const TextStyle(
                          color: Color(0xFFB3382C),
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        key: const Key('signInButton'),
                        onPressed: _signIn,
                        style: FilledButton.styleFrom(
                          backgroundColor: _green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F0EA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: _muted,
                            height: 1.6,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: 'Accès démo  ',
                              style: TextStyle(
                                color: _ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: 'identifiant '),
                            TextSpan(
                              text: 'demo',
                              style: TextStyle(
                                color: _green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(text: ' · mot de passe '),
                            TextSpan(
                              text: 'demo123',
                              style: TextStyle(
                                color: _green,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, size: 20),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: _green, width: 1.5),
    ),
  );
}

class PortfolioShell extends StatefulWidget {
  const PortfolioShell({required this.onSignOut, super.key});

  final VoidCallback onSignOut;

  @override
  State<PortfolioShell> createState() => _PortfolioShellState();
}

class _PortfolioShellState extends State<PortfolioShell> {
  int _selectedIndex = 0;

  static const _pages = [CvPage(), FamilyPage(), ContactPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _paper,
        titleSpacing: 24,
        title: Text(
          ['Mon CV', 'Ma famille', 'Me contacter'][_selectedIndex],
          style: const TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            key: const Key('signOutButton'),
            tooltip: 'Se déconnecter',
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout_rounded, color: _muted),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge_rounded),
            label: 'Mon CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.diversity_3_outlined),
            selectedIcon: Icon(Icons.diversity_3_rounded),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('cvPage'),
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _ink,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const ProfilePhoto(size: 76),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lukoo Bauma Meshack',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Développeuse mobile',
                          style: TextStyle(color: Color(0xFFB9C9C4)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'PROFIL DÉMO · À PERSONNALISER',
                style: TextStyle(
                  color: Color(0xFF9CD2B5),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Passionnée par la création d’expériences numériques utiles et soignées. J’aime transformer des idées en produits simples, accessibles et agréables à utiliser.',
                style: TextStyle(color: Color(0xFFE2E9E6), height: 1.6),
              ),
              const SizedBox(height: 18),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _DarkTag(label: 'Goma, RDC'),
                  _DarkTag(label: 'Disponible'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const SectionHeading(title: 'Formation', trailing: '01'),
        const SizedBox(height: 12),
        const TimelineCard(
          period: '2021 — 2024',
          title: 'Licence informatique',
          subtitle: 'Formation en développement logiciel · Goma',
        ),
        const SizedBox(height: 24),
        const SectionHeading(title: 'Expériences', trailing: '02'),
        const SizedBox(height: 12),
        const TimelineCard(
          period: '2024 — AUJOURD’HUI',
          title: 'Développeuse Flutter',
          subtitle: 'Studio numérique · Applications mobiles et interfaces accessibles',
        ),
        const SizedBox(height: 10),
        const TimelineCard(
          period: 'ÉTÉ 2023',
          title: 'Stage en développement',
          subtitle: 'Atelier web · Création d’un tableau de bord client',
        ),
        const SizedBox(height: 24),
        const SectionHeading(title: 'Compétences', trailing: '03'),
        const SizedBox(height: 12),
        const InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TECHNIQUES',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SkillTag(label: 'Flutter'),
                  SkillTag(label: 'Dart'),
                  SkillTag(label: 'Firebase'),
                  SkillTag(label: 'Git'),
                  SkillTag(label: 'Figma'),
                ],
              ),
              SizedBox(height: 18),
              Text(
                'LANGUES',
                style: TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Français · courant     Anglais · professionnel',
                style: TextStyle(color: _ink, height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeading(title: 'En dehors du code', trailing: '04'),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            InterestChip(
              icon: Icons.camera_alt_outlined,
              label: 'Photographie',
            ),
            InterestChip(icon: Icons.hiking_rounded, label: 'Randonnée'),
            InterestChip(icon: Icons.menu_book_rounded, label: 'Lecture'),
            InterestChip(icon: Icons.soup_kitchen_outlined, label: 'Cuisine'),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Les informations et portraits sont des exemples à remplacer par vos données.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 11, height: 1.5),
        ),
      ],
    );
  }
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  static const _members = [
    FamilyMember(
      name: 'Aïssatou Bauma',
      relation: 'Maman',
      profession: 'Enseignante',
      color: Color(0xFFDCECE4),
    ),
    FamilyMember(
      name: 'Mamadou Bauma',
      relation: 'Papa',
      profession: 'Ingénieur',
      color: Color(0xFFE9E6DA),
    ),
    FamilyMember(
      name: 'Lina Bauma',
      relation: 'Petite sœur',
      profession: 'Étudiante en design',
      color: Color(0xFFF1E2DC),
    ),
    FamilyMember(
      name: 'Ibrahim Bauma',
      relation: 'Grand frère',
      profession: 'Entrepreneur',
      color: Color(0xFFE4E6F0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('familyPage'),
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
      children: [
        const Text(
          'Mon premier cercle',
          style: TextStyle(
            color: _ink,
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Les personnes qui m’inspirent au quotidien.',
          style: TextStyle(color: _muted, height: 1.5),
        ),
        const SizedBox(height: 20),
        ..._members.map(
          (member) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FamilyCard(member: member),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Exemple de famille — personnalisez les noms, photos et professions.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 11, height: 1.5),
        ),
      ],
    );
  }
}

class FamilyMember {
  const FamilyMember({
    required this.name,
    required this.relation,
    required this.profession,
    required this.color,
  });

  final String name;
  final String relation;
  final String profession;
  final Color color;
}

class FamilyCard extends StatelessWidget {
  const FamilyCard({required this.member, super.key});

  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Row(
        children: [
          ProfilePhoto(size: 64, backgroundColor: member.color),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  member.relation,
                  style: const TextStyle(
                    color: _green,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.profession,
                  style: const TextStyle(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.favorite_rounded,
            color: Color(0xFFDC9D88),
            size: 19,
          ),
        ],
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('contactPage'),
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.waving_hand_rounded, color: Color(0xFFD1E9D8)),
              SizedBox(height: 14),
              Text(
                'Parlons de votre projet.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Une idée, une opportunité ou simplement envie d’échanger ? Ma boîte mail est ouverte.',
                style: TextStyle(color: Color(0xFFDCEBE0), height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionHeading(title: 'Mes coordonnées', trailing: '01'),
        const SizedBox(height: 12),
        const ContactCard(
          icon: Icons.phone_outlined,
          label: 'TÉLÉPHONE',
          value: '+243 000 000 000',
          uri: 'tel:+243000000000',
        ),
        const SizedBox(height: 10),
        const ContactCard(
          icon: Icons.mail_outline_rounded,
          label: 'E-MAIL',
          value: 'lukoo.bauma.meshack@example.com',
          uri: 'mailto:lukoo.bauma.meshack@example.com',
        ),
        const SizedBox(height: 10),
        const ContactCard(
          icon: Icons.location_on_outlined,
          label: 'ADRESSE',
          value: 'Goma, RDC',
          uri: 'https://www.google.com/maps/search/?api=1&query=Goma%2C%20RDC',
        ),
        const SizedBox(height: 24),
        const SectionHeading(title: 'Retrouvez-moi en ligne', trailing: '02'),
        const SizedBox(height: 12),
        const ContactCard(
          icon: Icons.work_outline_rounded,
          label: 'LINKEDIN',
          value: 'linkedin.com/in/lukoo-bauma-meshack',
          uri: 'https://linkedin.com/in/lukoo-bauma-meshack',
        ),
        const SizedBox(height: 10),
        const ContactCard(
          icon: Icons.code_rounded,
          label: 'GITHUB',
          value: 'github.com/lukoobaumameshack',
          uri: 'https://github.com/lukoobaumameshack',
        ),
        const SizedBox(height: 18),
        const Text(
          'Coordonnées fictives de démonstration — remplacez-les avant publication.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 11, height: 1.5),
        ),
      ],
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.uri,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final String uri;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication),
      borderRadius: BorderRadius.circular(18),
      child: InfoCard(
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F0EA),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: _green, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    required this.size,
    this.backgroundColor = const Color(0xFFDCECE4),
    super.key,
  });

  final double size;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: Image.asset(
          'web/Lukoo_Bauma_Meshack.JPG',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person_rounded, size: size * 0.62, color: _green),
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    required this.trailing,
    super.key,
  });

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ),
        Text(
          trailing,
          style: const TextStyle(
            color: _green,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class TimelineCard extends StatelessWidget {
  const TimelineCard({
    required this.period,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String period;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 62,
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period,
                  style: const TextStyle(
                    color: _green,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _muted,
                    height: 1.4,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class SkillTag extends StatelessWidget {
  const SkillTag({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0EA),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _green,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class InterestChip extends StatelessWidget {
  const InterestChip({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: _green, size: 16),
      label: Text(label),
      backgroundColor: Colors.white,
      side: const BorderSide(color: _line),
      labelStyle: const TextStyle(color: _ink, fontSize: 11),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }
}

class _DarkTag extends StatelessWidget {
  const _DarkTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3B41),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFE3EBE7),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
