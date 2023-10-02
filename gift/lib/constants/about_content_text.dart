import 'package:flutter/material.dart';
import 'constants.dart';

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(50.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextSection(
                title: 'Gift App',
                content: TextSpan(
                  text:
                      'The ultimate way to celebrate special moments with your loved ones through personalized gifts and heartfelt messages./'
                      'Designed and developed by Houasnia Aymen Ahmed, this app aims to bring joy and connection to your friendships.',
                ),
              ),
              SizedBox(height: 20),
              RichTextSection(
                title: 'Purpose',
                content: TextSpan(
                  text:
                      'Gift App is all about sharing joy. Our main purpose is to provide a simple and fun platform for sending personalized gifts as notifications to your friends. /'
                      'Not only that, but you can also display heartwarming messages in both the app and on your Android home screen, keeping those special moments close to your heart.',
                ),
              ),
              SizedBox(height: 20),
              RichTextSection(
                title: 'Key Features',
                content: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: '* Send Gifts: ', style: aboutSubTitleStyle),
                    TextSpan(
                        text:
                            'Surprise your friends with thoughtful gifts delivered right to their notifications.\n'),
                    TextSpan(
                        text: '* Widget Messages: ', style: aboutSubTitleStyle),
                    TextSpan(
                        text:
                            'Display messages on the app\'s widget and the Android home screen, making every day a celebration.\n'),
                    TextSpan(
                        text: '* Friend Interaction: ',
                        style: aboutSubTitleStyle),
                    TextSpan(
                      text:
                          'Connect with your friends in a unique and memorable way, fostering deeper relationships.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              RichTextSection(
                title: 'User Benefits',
                content: TextSpan(
                  style: TextStyle(fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(text: 'With Gift App, you\'ll enjoy:\n'),
                    TextSpan(
                        text: '* Personalized Gifting:',
                        style: aboutSubTitleStyle),
                    TextSpan(
                        text:
                            'Show your appreciation and love by sending personalized gifts for various occasions.\n'),
                    TextSpan(
                        text: '* Easy Interaction: ',
                        style: aboutSubTitleStyle),
                    TextSpan(
                        text:
                            'Stay connected effortlessly, making every interaction a joyful experience.\n'),
                    TextSpan(
                        text: '* Celebrating Together: ',
                        style: aboutSubTitleStyle),
                    TextSpan(
                      text:
                          'Whether it\'s a birthday, an achievement, or just a simple "thinking of you," Gift App helps you celebrate together, no matter the distance.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              RichTextSection(
                title: 'Mission',
                content: TextSpan(
                  text:
                      'Our mission is to spread happiness through meaningful connections. We believe that even a small gesture can make a big impact on someone\'s day. Gift App is here to help you create these moments of joy and connection, one notification at a time.',
                ),
              ),
              SizedBox(height: 20),
              RichTextSection(
                title: 'Developer',
                content: TextSpan(
                  text:
                      'Gift App is the brainchild of Houasnia Aymen Ahmed, who is passionate about creating simple yet powerful experiences that touch people\'s lives.\n\nContact Houasnia Aymen Ahmed:\n',
                  children: [
                    TextSpan(
                        text:
                            '- Email: aymenaymen2056@gmail.com\n- Phone: +213673407157',
                        style: TextStyle(fontWeight: FontWeight.w600))
                  ],
                ),
              ),
              SizedBox(height: 20),
              RichTextSection(
                title: 'Privacy and Permissions',
                content: TextSpan(
                  text:
                      'Gift App requires access to your gallery and camera to help you create and personalize the perfect gifts. Additionally, the app uses notifications to ensure your friends never miss a heartfelt moment.',
                ),
              ),
              SizedBox(height: 20),
              RichTextSection(
                  title: 'Acknowledgments',
                  content: TextSpan(
                    text:
                        'Gift App is built using Firebase for authentication, storage, messaging, and notifications.',
                  )),
              SizedBox(height: 20),
              RichTextSection(
                title: 'Version History',
                content: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: '* v1.0.0: ', style: aboutSubTitleStyle),
                    TextSpan(
                        text:
                            'The initial version laid the foundation for sending gifts and messages.\n\n'),
                    TextSpan(text: '* v2.0.0: ', style: aboutSubTitleStyle),
                    TextSpan(
                      text:
                          'This major update brings network checking, UI improvements, and more, enhancing your gifting experience.\n\n',
                    ),
                    TextSpan(text: '* v2.0.1: ', style: aboutSubTitleStyle),
                    TextSpan(
                      text: 'Fixes found bugs.\n\n',
                    ),
                    TextSpan(text: '* v2.0.2: ', style: aboutSubTitleStyle),
                    TextSpan(
                      text: 'Changes some content (Bottom Sheet).\n\n',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RichTextSection extends StatelessWidget {
  final String title;
  final TextSpan content;

  const RichTextSection(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white),
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              content,
            ],
          ),
        ),
      ],
    );
  }
}
