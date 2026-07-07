---
title: "Aedes AI Implementation Phase 1"
date: 2026-05-10
type: research
area: ""
project: hotel-investment
tags: [type/research, project/hotel-investment, status/archived, topic/hospitality, topic/ai, topic/strategy]
status: archived
---


# **Phase 1 AI Implementation Report: Foundation & Enablement for Aedes**

## **Executive Summary**

This report outlines Phase 1 of Aedes’ five-phase AI implementation approach, focusing on establishing a robust foundation for responsible and effective AI adoption. The primary objectives of this phase are to develop a comprehensive AI usage policy, empower staff through targeted training, and set up a secure, centralized AI environment. By addressing these critical areas, Aedes aims to minimize risks, ensure compliance, and maximize the potential for AI to enhance guest experiences and operational efficiency. This foundational phase is crucial for building trust, fostering innovation, and positioning Aedes as a leader in leveraging AI within the hospitality sector.

## **1\. Introduction: Laying the Groundwork for AI at Aedes**

Phase 1, titled “Foundation & Enablement,” is designed to create a secure, ethical, and well-understood framework for AI adoption across Aedes. This initial phase addresses critical aspects of governance, capability building, and infrastructure, ensuring that AI is introduced responsibly and effectively throughout the organization. It serves as the essential bedrock upon which all subsequent AI initiatives will be built, strategically minimizing potential risks while maximizing the potential for positive impact across all departments.

The hospitality industry is currently experiencing a rapid transformation driven by AI, with significant projections indicating a massive increase in adoption and investment. Analyst estimates suggest the market for AI technology in hospitality was approximately $90 million in 2023 and is expected to rise rapidly at a rate of 60% each year, potentially topping $8 billion by 2033\.1 This substantial growth is propelled by AI's proven ability to bolster profitability, significantly improve guest services, and enhance operational systems across the entire hotel business, from the front desk to the back office.1

Specific applications of AI within the sector include AI-enhanced analytics for making smarter decisions regarding cost management and pricing strategies, improving guest experiences through staff augmentation and automation, and supporting critical sustainability goals.1 Furthermore, AI can personalize service and guest interactions, power virtual assistants and chatbots for quick inquiries and booking assistance, optimize housekeeping schedules, facilitate real-time translation, and enhance overall security measures.1

The rapid projected growth of AI in hospitality presents a compelling business imperative for Aedes. If the market is indeed growing at 60% annually, and a significant portion of hotels and travel agencies (60-70%) plan to integrate AI 1, then Aedes’ early, structured adoption is not merely an option but a strategic necessity. Delaying AI integration could lead to a widening competitive gap, making it costly for Aedes to catch up with industry leaders in an increasingly AI-driven landscape.3 Therefore, Phase 1 is not just about establishing technology; it is about securing Aedes' future market position and ensuring its continued competitiveness.

## **2\. AI Usage Policy & Governance: Ensuring Trust and Compliance**

### **2.1 Draft AI Usage Policy: Core Principles & Components**

A comprehensive AI usage policy is indispensable for Aedes to maintain a safe and secure environment for all employees and partners. This policy ensures the responsible use of AI technology, particularly when handling the organization's sensitive and confidential information.4 It provides clear guidelines and best practices, acknowledging AI's increasing prevalence in day-to-day work.4

Key components that must be integrated into Aedes' AI Usage Policy include:

* **Confidentiality and Data Protection:** Staff must be strictly prohibited from uploading or sharing any personal, proprietary, or protected data without prior approval from the appropriate department. This includes, but is not limited to, personally identifiable information (PII), passwords, certificates, secrets, and tokens.4 All sensitive customer data must be treated as highly confidential and explicitly not disclosed during any interactions with AI or large language model (LLM) platforms.5 Furthermore, data should be encrypted both in transit and at rest, and where feasible, anonymized or de-identified before being processed by AI tools to protect individual privacy.6  
* **Access Control:** Employees must not grant access to AI tools outside the organization without prior approval, which includes sharing login credentials or other sensitive information with third parties.4 Multi-factor authentication (MFA) should be a mandatory requirement across all third-party tools and technologies used for generative AI services.4  
* **Acceptable Use:** The use of generative AI tools must be strictly limited to business-related purposes and must align with Aedes' organizational standards.4 All assets created using generative AI systems must be professional and respectful, and staff should explicitly avoid using offensive, abusive, discriminatory, harassing, or biased language when applying generative techniques.4  
* **Legal & Regulatory Compliance:** All AI systems and their usage within Aedes must comply with all applicable laws and regulations. This includes, but is not limited to, data protection and privacy laws such as GDPR and CCPA, as well as relevant financial industry guidelines like PCI DSS.4  
* **Monitoring & Review:** Aedes reserves the right to review and monitor all communications shared with generative AI systems, including messages, prompts, attachments, and files.4 Periodic audits and assessments of AI and LLM usage are required to ensure ongoing security, compliance, and quality assurance.5  
* **Bias, Equity, and Trust Concerns:** As issues related to equity, bias, and trust can arise with AI tools, it is the explicit responsibility of staff to bring these concerns to their supervisor.4  
* **Staff Responsibility:** All staff are responsible for ensuring their use of AI technology complies with this Acceptable Usage Policy and any other relevant organizational policies. They must be aware of their responsibilities for protecting confidential and sensitive information and take all necessary steps to safeguard privacy and security when using generative AI technology.4 Managers and supervisors are responsible for ensuring their teams understand and comply with this policy and for reporting any violations to the appropriate department.4 Explicit consent must always be obtained before using AI tools to create content that involves another person.4  
* **Policy Updates:** This Acceptable Use of AI Tools Policy will be updated periodically to reflect the dynamic and changing nature of AI tool usage. Changes will be informed by potential risks and biases introduced by these tools and by evolving cybersecurity recommendations.4

The consistent emphasis on "periodically updated" policies 4 and the need to "address emerging risks, changes in regulations, or advancements in technology" 5 highlights that AI governance is not a static document but an ongoing, adaptive process. For Aedes, this means the IT and Legal departments must establish a regular review cycle for the policy, perhaps quarterly or bi-annually, to ensure it remains relevant and effective in a rapidly evolving technological and regulatory landscape. This continuous operational requirement underscores the dynamic nature of responsible AI.

Furthermore, the policy's explicit requirement for staff to "bring these issues to their supervisor" regarding equity, bias, and trust concerns 4 establishes a crucial mechanism for ethical AI. While AI models can learn and perpetuate biases, human vigilance remains indispensable.7 Empowering every staff member to identify and report such issues creates a distributed, real-time ethical oversight system. This is a practical, actionable step that non-technical staff can directly contribute to, reinforcing that responsible AI is a collective responsibility, not solely an IT function.

| Policy Area | Key Guideline | Rationale |
| :---- | :---- | :---- |
| **Data Confidentiality** | Do not upload personal, proprietary, or protected data without prior approval. Treat all customer information as highly confidential. | To prevent data breaches, comply with privacy laws (e.g., GDPR, CCPA), and protect Aedes' intellectual property. |
| **Access Control** | Do not grant external access to AI tools or share login credentials. Use Multi-Factor Authentication (MFA). | To prevent unauthorized access and maintain system security. |
| **Acceptable Use** | Limit AI tool use to business-related purposes. All AI-created assets must be professional and respectful. | To ensure AI supports Aedes' objectives and maintains brand reputation. |
| **Compliance & Legal** | All AI usage must comply with applicable laws and regulations (e.g., GDPR, CCPA, PCI DSS). | To avoid legal penalties and maintain Aedes' regulatory standing. |
| **Oversight & Monitoring** | Aedes reserves the right to review and monitor AI communications. Periodic audits of AI usage will be conducted. | To ensure adherence to policy, identify risks, and maintain security and quality standards. |
| **Bias & Ethics** | Staff are responsible for reporting any equity, bias, or trust concerns with AI tools to their supervisor. | To proactively identify and mitigate ethical risks and ensure fair outcomes. |
| **Staff Responsibility** | All staff are accountable for complying with this policy and safeguarding confidential information. Managers must ensure team compliance. | To foster a culture of responsible AI use and distributed accountability. |
| **Policy Updates** | The policy will be updated periodically to reflect evolving AI tools, risks, and cybersecurity recommendations. | To ensure the policy remains relevant and effective in a dynamic technological and regulatory environment. |

### **2.2 Vendor & Data Clauses: Protecting Aedes' Interests**

AI vendor contracts often present significant challenges, as they frequently prioritize the vendor's interests. Research indicates that 92% of AI vendors claim broad data usage rights, often exceeding what is necessary for service delivery, and 88% impose liability caps.8 This contractual imbalance can shift substantial risk and compliance burdens onto the customer, potentially leaving Aedes responsible for issues stemming from the vendor's AI model or data handling.8

To mitigate these risks, Aedes must demand specific contractual clauses:

* **Explicit Prohibition on Model Training:** Aedes must insist on an express prohibition against the supplier using any Aedes customer data, including inputs (prompts) or outputs generated by the AI tool, to train their own models or any third-party models.9 This is paramount to protecting Aedes' proprietary information, guest data, and intellectual property.  
* **Clear Data Ownership & Confidentiality:** Contracts must clearly specify that Aedes retains ownership of its intellectual property rights, including top-up training data, inputs, and outputs generated by the AI tool.9 All inputs, outputs, and any customer-provided training data must be treated as confidential information by the vendor.9 This prevents the supplier from using Aedes’ inputs in their training data, which could indirectly benefit future users or lead to competition and intellectual property issues.9  
* **Secure Data Processing & Channels:** Agreements should mandate that all AI platform interactions occur over secure, encrypted channels and on systems with appropriate security measures. These measures are crucial to protect Aedes' information from unauthorized access or disclosure.5  
* **Supplier Compliance Guarantees:** Vendors should explicitly warrant their compliance with all relevant laws and regulations, such as GDPR and CCPA.9 They should also commit to conducting and regularly updating Data Protection Impact Assessments (DPIAs) and ethical risk assessments for their AI products.9  
* **Performance Warranties & Remedies:** Aedes should seek robust performance warranties linked to specific performance metrics and reliability standards. These warranties should include clear remedies, such as model retraining or service credits, in cases of non-compliance, particularly for high-stakes applications where accuracy is critical.8  
* **Governance and Audit Rights:** The contract should allow for more in-depth governance and audit rights. This includes requiring suppliers to provide reports on risks such as security incidents, bias, inaccurate performance, "hallucinations" (AI-generated inaccuracies), and intellectual property infringement.9  
* **Vendor Risk Management Integration:** All AI vendors must undergo a thorough review in accordance with Aedes' existing Vendor Risk Management policy, and a comprehensive impact analysis must be completed before any usage approval is granted.5

The data explicitly states that AI vendor contracts "favor providers by limiting liability and shifting compliance burdens onto customers".8 This contractual pattern represents a critical, often hidden, risk. It means Aedes could inadvertently assume responsibility for AI-generated biases, privacy violations, or intellectual property infringements, even if the underlying issue stems from the vendor's model or data handling. Therefore, the legal and procurement teams must be exceptionally vigilant, going beyond standard SaaS contract reviews to specifically negotiate clauses that protect Aedes from these unique AI-related liabilities, rather than assuming vendor responsibility.

Furthermore, the option for vendors to deploy "local versions of their model within the customer's IT estate" 9 or the assurance that data "remains within the Microsoft 365 service boundary" 10 points to a strategic imperative for data sovereignty. While public cloud AI services offer convenience, the ultimate control over proprietary and sensitive guest data is paramount. For Aedes, this implies a strategic decision point: for highly sensitive data or core business processes, prioritizing AI solutions that guarantee data never leaves Aedes' controlled environment (or a tightly controlled service boundary) might outweigh the simplicity of purely public cloud models. This ensures maximum protection against unauthorized data use for training or competitive intelligence.8

### **2.3 Approved AI Tools List: Vetted for Security**

The primary criteria for selecting AI tools must be enterprise-grade security and privacy, clear commitments against using Aedes' business data for model training, robust compliance certifications, and comprehensive administrative controls. The initial recommendations for approved tools, vetted for security and privacy, include:

* **ChatGPT Enterprise (OpenAI):**  
  * **Data Usage:** OpenAI explicitly states that they do not train their models on business data or conversations, and their models do not learn from user usage.11 Aedes retains ownership and control over its business data within ChatGPT Enterprise.11  
  * **Security & Compliance:** The platform is SOC2 compliant, indicating adherence to specific trust principles for security, availability, processing integrity, confidentiality, and privacy. All conversations are encrypted both in transit (while being sent) and at rest (when stored).11  
  * **Admin Controls:** A new admin console allows for easy management of team members, domain verification, Single Sign-On (SSO), and usage insights, facilitating large-scale deployment into an enterprise.11  
* **Microsoft Copilot (Microsoft 365 Copilot):**  
  * **Data Usage:** Customer data, including prompts and responses, is not used to train Microsoft's foundation models. Prompts and responses are not stored or used outside the organization's boundaries.10 Data remains within the Microsoft 365 service boundary, and the service uses Azure OpenAI (not OpenAI's publicly available services) for processing.10  
  * **Security & Compliance:** Microsoft 365 Copilot complies with existing privacy, security, and compliance commitments for Microsoft 365 commercial customers, including GDPR and the EU Data Boundary.10 It honors existing Microsoft 365 permissions, ensuring data access is restricted to authorized users.10 The service also includes protections against harmful content, detection of protected material, and blocking of prompt injections (jailbreak attacks).10  
  * **Admin Controls:** Administrators can view and manage stored interaction data using Content search or Microsoft Purview and set retention policies. Users also have the ability to delete their Copilot activity history.10  
* **Gemini Workflows (Google Workspace):**  
  * **Data Usage:** Interactions with Gemini stay within the organization and are not shared outside the organization without permission.13 Content is not used for any other customers or for generative AI model training outside the domain without permission.13 Personal content that Gemini Apps retrieve from other Google services is not human-reviewed or used to improve generative machine learning technologies.14  
  * **Security & Compliance:** Gemini brings the same enterprise-grade security as the rest of Google Workspace, automatically applying existing controls.13 A strict data access control model prevents content leakage across user boundaries.13 Client-side encryption (CSE) can further restrict Gemini's access to sensitive data.13 It is compliant with GDPR.14  
  * **Admin Controls:** Administrators can manage conversation history retention, with options to auto-delete after 3, 18, or 36 months.13  
* **Private Claude Workspace (Anthropic):**  
  * **Data Usage:** By default, Anthropic states that it will not use Claude for Work data (inputs or outputs) to train its models.15 For consumer products (Claude Free, Claude Pro), data is not used for training unless explicitly reported or opted-in by the user.16  
  * **Security & Compliance:** Data transmissions are encrypted.16  
  * **Admin Controls:** The enterprise plan offers robust controls for access management, including SSO, domain capture, role-based access with fine-grained permissioning, System for Cross-domain Identity Management (SCIM) for user provisioning, audit logs, and custom data retention periods for chats and projects.15

While all recommended enterprise tools explicitly state "no training on your data" for their enterprise offerings, a closer examination reveals nuances. For instance, Google's consumer-facing Gemini Apps Activity is "on by default" 14 and allows human reviewers (though disconnected from accounts).14 This highlights a critical point for Aedes: during procurement and setup, the IT department must meticulously scrutinize the

*enterprise-specific terms, default settings, and configuration options* to ensure these align with Aedes' strict privacy policy. This proactive approach is essential to prevent any inadvertent data exposure, even if the general enterprise promise is "no training." This requires a deep dive into the specific enterprise agreements and configurations.

Furthermore, the comparison reveals that a "no data training" clause, while crucial, is only one component of enterprise-grade security. Other vital features such as SOC2 compliance 11, encryption at rest and in transit 6, robust admin consoles with SSO and audit logs 11, and adherence to data residency requirements (e.g., EU Data Boundary) 10 are equally important. For Aedes, this means the selection process must be holistic, evaluating the vendor's entire security posture and compliance framework, rather than focusing solely on the data training clause. This comprehensive view ensures a truly secure environment for sensitive hospitality data.

| AI Tool | Data Used for Model Training | Data Encryption | Key Compliance Certifications | Key Admin Controls | Human Review Policy | Key Differentiators |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| **ChatGPT Enterprise** | No, by default, for business data. Models do not learn from usage. | In transit & at rest | SOC2 | Admin console for team management, domain verification, SSO, usage insights. | None for enterprise business data/conversations. | Strong focus on enterprise-grade security and privacy. |
| **Microsoft Copilot** | No, for prompts, responses, or data accessed via Microsoft Graph. Data stays within Microsoft 365 service boundary. | In transit & at rest | GDPR, EU Data Boundary, Microsoft 365 commercial commitments. | Content search, Microsoft Purview for data management/retention; user history deletion; agent management. | Opted out of abuse monitoring (no human review of content for enterprise). | Deep integration with Microsoft 365 ecosystem and permissions. |
| **Gemini Workflows** | No, content not used for model training outside domain without permission. Personal content from Google services not used for model improvement. | Implied by Google Workspace security. | GDPR, SOC 1/2/3, ISO 9001, ISO/IEC 27001, 27701, 27017, 27018, 42001\. | Admin controls for conversation history retention (3/18/36 months auto-delete). | Human reviewers for consumer products (disconnected from account), not for personal content from Google services. | Leverages existing Google Workspace security and controls. |
| **Private Claude Workspace** | No, by default, for Claude for Work data. | Data transmissions are encrypted. | Not explicitly listed, but implies adherence to rigorous privacy policies. | SSO, domain capture, role-based access, SCIM, audit logs, custom data retention periods. | No training on user data unless explicitly reported or opted-in (consumer products). | Focus on "Constitutional AI" framework for safety and ethical principles. |

## **3\. Skills Development & Training: Empowering Our Team**

### **3.1 Introductory Workshop: Understanding AI's Potential & Limits**

An introductory workshop is essential to educate Aedes staff on the capabilities and limitations of AI, fostering realistic expectations and encouraging responsible usage.

**What AI Can Do for Aedes (Capabilities):**

* **Content Generation:** AI can efficiently create a wide range of content, including social media posts, marketing copy, and guest replies, significantly boosting productivity in communication and marketing departments.1  
* **Guest Communication:** AI powers sophisticated chatbots and virtual assistants capable of providing booking assistance, answering frequently asked questions (FAQs), facilitating real-time translation for international guests, and offering personalized recommendations.1 Examples include Marriott's RENAI virtual concierge and Hilton's Connie robot, which handle routine inquiries and provide local information.19  
* **Operational Efficiency:** AI can automate repetitive tasks, optimize housekeeping schedules, facilitate dynamic pricing strategies, and streamline internal document management, such as organizing meeting notes, rewriting emails, processing assessments, and simplifying invoicing.1  
* **Personalization:** AI enables highly tailored guest experiences, from customized in-room settings and entertainment systems to personalized loyalty rewards, enhancing guest satisfaction and potentially driving higher occupancy rates.1  
* **Decision Support:** AI can analyze large datasets, identify patterns, extract valuable insights, and generate hypotheses and recommendations, assisting Aedes in making smarter decisions regarding cost management, pricing, and strategic planning.1

**What AI Cannot Do (Limitations & Risks):**

* **"Hallucinations" & Inaccuracy:** AI models can produce plausible but factually incorrect, nonsensical, or inconsistent outputs.7 Human verification is always necessary for critical information, as AI should be a support tool, not the sole source of truth.6  
* **Inconsistency:** The probabilistic nature of AI models can lead to different outputs for the same inputs, which may be undesirable in applications requiring high consistency.7  
* **Bias:** AI models may learn and perpetuate societal biases present in their training data, leading to biased, unfair, or offensive content.4 This necessitates careful monitoring and human oversight.  
* **Lack of Explainability:** Many advanced AI models operate as "black boxes," making it challenging to fully understand their decision-making processes or the logic behind their outputs.7  
* **Security & Privacy Threats:** AI systems can be manipulated by malicious actors (e.g., to generate harmful code or assist with unauthorized system access), exploited for phishing, or lead to unauthorized data access if not properly secured.6  
* **Intellectual Property Infringement:** There is a risk of AI-generated content inadvertently infringing on third-party intellectual property rights, requiring careful content moderation and verification.6  
* **Support Tool, Not Sole Source:** It is crucial to emphasize that AI should be used as a support tool rather than the sole source of information for critical decisions or actions.5

A significant area of concern for non-technical staff regarding AI adoption is potential job displacement. The available information consistently highlights AI's role in "staff augmentation" 1 and empowering teams with "smarter data, faster decisions" 21, rather than outright replacement. One document explicitly introduces the concept of "augmented workers" who use AI to "perform tasks better".2 The introductory workshop must proactively address these concerns by framing AI as a tool that frees up employees from "monotonous tasks" 20 to focus on "higher-value, more creative work".7 This shifts the narrative from threat to opportunity, fostering psychological safety and encouraging enthusiastic adoption across the organization.

### **3.2 Prompting Basics: Communicating Effectively with AI**

Prompt engineering is a critical skill for optimizing AI outputs, ensuring they are relevant, accurate, and aligned with desired goals.7 It is a relatively new discipline focused on developing and optimizing prompts to efficiently use language models for a wide variety of applications.23 Mastering these basics empowers users to effectively communicate with and leverage AI tools.

Core principles of effective prompt engineering include:

* **Clear & Specific Instructions:** Treat the LLM like a student learning a new skill; provide as much information and context as possible to achieve a positive result. Avoid ambiguous language and define any domain-specific jargon, acronyms, or initialisms, as the model may not know them.24  
* **Context-Rich Prompts:** Offer an appropriate amount of detail about the context of the request. Ambiguous prompts often lead to irrelevant or vague responses. For example, instead of a general prompt like "Tell me about historical conflicts," be specific: "Tell me about the causes of World War II".25  
* **Iterative Refinement:** Plan to iterate on prompts. The best results often come from refining prompts based on the AI's initial responses. This involves simplifying, summarizing, expanding, or changing the tone of the output.7  
* **Specify Output Format & Length:** Clearly state the desired structure of the output (e.g., a list, a draft, a narrative, a summary), its length, and any character limitations. For instance, "The output should be no more than 500 words, in a formal tone suitable for federal contracting".24  
* **Incorporate Examples (Few-shot Prompting):** For complex tasks, specific formats, or nuanced tones, provide concrete examples that demonstrate the desired input-output pattern. This helps clarify expectations and reduces ambiguity.7  
* **Break Down Complex Tasks (Chain-of-Thought):** For multi-step or complex requests, break the prompt into smaller, sequential parts to guide the AI's reasoning step-by-step. For example, instead of asking for a report and solutions on inflation at once, first ask to "Explain the current inflation rate," then "Suggest practical solutions to decrease inflation".7  
* **Focus on Desired Outcome:** Frame prompts positively, focusing on what is wanted from the model rather than what to avoid. For example, instead of "Write a document without passive voice," say, "Write a document in active voice".25  
* **Define Role/Persona:** If the AI should adopt a specific persona or role, define it clearly in the system instructions.24

The available information consistently frames prompt engineering not just as a technical task but as a "new discipline" 23 and an "important skill" 23 for anyone interacting with LLMs. It directly impacts the "quality, relevance, and accuracy" of AI outputs.7 For Aedes, this implies that investing in prompt engineering training for all staff who will use AI is crucial for realizing the technology's benefits. This approach democratizes the ability to extract value from AI, extending beyond IT specialists to empower every employee to effectively communicate with and leverage AI tools, thereby directly impacting the return on investment of AI adoption.

### **3.3 Identifying Automation Opportunities: Streamlining Operations**

Identifying suitable tasks for AI assistance or automation is a critical step in leveraging the technology effectively. The most suitable candidates for process automation are repetitive tasks with formalized steps, sequences, and rules.22 Automation ensures the business process is done correctly every time, involving the right people, in the right order, with the right information, and within a specified timeframe. Ad-hoc or one-time activities are generally not ideal candidates for automation.22

While the available information does not detail specific methodologies for *identifying* these tasks, it highlights technologies that enable automation once identified:

* **Robotic Process Automation (RPA):** This involves software and bots programmed to emulate human actions for repetitive business tasks, such as navigating systems, reading and entering data, and performing rule-based tasks.22  
* **Intelligent Process Automation (IPA):** This emerging set of technologies combines process redesign with RPA and machine learning. IPA augments business processes with AI and next-generation tools to automate and simplify repetitive, replicable, and routine tasks, allowing systems to mimic human activities and learn to perform them.22  
* **Hyperautomation:** This is a strategic initiative to identify, vet, and automate as many business and IT processes as possible, as quickly as possible, integrating multiple technologies including AI/machine learning, RPA, and low-code/no-code development tools.22  
* **AI/Machine Learning (ML) Integration:** AI technologies can process and convert semi-structured and unstructured data (e.g., scanned images, webpages, PDF documents) into a structured format that RPA can understand and use. When integrated with RPA, AI, and Natural Language Processing (NLP), machine learning can spot trends and patterns, and learn from data and human users, making process automation more accurate and useful.22 NLP-powered chatbots, for instance, can learn from human speech and interpret context and tone to guide interactions and answer standard inquiries.22

For a practical session, examples relevant to the hospitality industry where AI can assist or automate repetitive tasks include:

* **Social Media Posts:** AI can generate dynamic campaigns and personalized content for social platforms, enhancing Aedes' online presence and engagement.1  
* **Guest Replies/Communication:** Chatbots and virtual assistants can handle frequently asked questions, booking assistance, real-time translation, and personalized recommendations, freeing up staff for more complex guest interactions.1 Notable examples include Marriott's RENAI virtual concierge and Hilton's Connie robot, which provide quick, personalized assistance.19  
* **Document Formatting/Internal Document Management:** AI can speed up monotonous tasks such as organizing meeting notes, rewriting emails, processing assessments, and simplifying invoicing, thereby improving back-office efficiency.20  
* **Other Potential Areas:** Recruitment activities (e.g., processing resumes), employee onboarding (e.g., records processing, compliance training), payment and payroll processes (e.g., contractor payments), workforce scheduling (e.g., syncing time off requests), customer experience workflows (e.g., routing inquiries), and compliance and regulatory tasks (e.g., logging activities for audit trails).22

The user query explicitly asks for a "practice session: identify repetitive tasks within your department." This, combined with the characteristics of suitable tasks 22, points to a strategy of democratizing automation identification. Instead of a top-down mandate, Aedes is empowering its employees—those who perform the tasks daily—to identify their own pain points that AI can solve. This bottom-up approach is crucial for high adoption rates and ensures that AI solutions address real, impactful business needs, leading to tangible efficiency gains and fostering a culture of continuous improvement and innovation from within the workforce.

| Hospitality Area | Current Manual Task (Example) | AI Solution | Potential Benefit |
| :---- | :---- | :---- | :---- |
| **Front Desk / Guest Services** | Answering repetitive guest FAQs (e.g., Wi-Fi password, check-out time, local recommendations). | AI Chatbot / Virtual Concierge | 24/7 instant replies, reduced staff workload, improved guest satisfaction, multilingual support. |
| **Marketing / Social Media** | Drafting routine social media posts and responding to common comments. | Generative AI for content creation | Faster content generation, consistent brand voice, increased engagement, reduced manual effort. |
| **Guest Communications** | Crafting personalized guest replies for common inquiries (e.g., reservation changes, special requests). | AI-powered email/chat drafting assistant | Quicker, more consistent, and personalized responses, improved guest satisfaction. |
| **Back Office / Admin** | Organizing meeting notes, summarizing long documents, reformatting reports. | AI-powered document management/summarization tools | Significant time savings, improved document consistency, enhanced information retrieval. |
| **Human Resources** | Processing new employee onboarding paperwork, scheduling training sessions. | Robotic Process Automation (RPA) / AI-assisted workflows | Faster onboarding, reduced administrative errors, quicker employee productivity. |

## **4\. Secure AI Environment Setup: Building Our Digital Workspace**

### **4.1 Choosing a Single, Secure AI Workspace**

Selecting a single, secure AI workspace is a critical decision for Aedes. This approach ensures consistent data privacy and security standards across the organization, streamlines management, and simplifies compliance efforts. It is essential to prevent the proliferation of unvetted tools and fragmented data, which could introduce significant security vulnerabilities and compliance risks.

Based on the detailed comparison in Section 2.3, Aedes needs to select one primary enterprise-grade AI platform from options such as ChatGPT Enterprise, Microsoft Copilot, Gemini Workflows, or a private Claude workspace. The choice should be strategically aligned with Aedes' existing IT infrastructure. For instance, if Aedes is heavily invested in Microsoft 365, Copilot might be a natural fit due to its seamless integration with existing data and permission models.10 This strategic alignment maximizes utility, minimizes integration complexities, and allows the company to capitalize on existing security and access control mechanisms, impacting deployment speed, user adoption, and overall total cost of ownership.

The chosen platform must guarantee that Aedes' business data is *not* used for public model training, offer robust encryption (both in transit and at rest), provide comprehensive administrative controls (including Single Sign-On and audit logs), and comply with relevant data protection regulations (such as GDPR, EU Data Boundary, and SOC2 certifications).

### **4.2 Shared Prompt Library: Fostering Consistency & Efficiency**

Establishing a centralized AI prompt repository is crucial for Aedes to foster consistency and efficiency in its AI-powered operations. This repository acts as a single source of truth for AI-generated content, ensuring consistent brand messaging, increasing efficiency, improving collaboration, and enabling scalable workflows across departments.26

Key benefits of a centralized prompt library include:

* **Consistent Brand Messaging:** It standardizes the tone, style, and messaging across all channels, which is vital for building guest trust and maintaining Aedes' brand identity.27  
* **Increased Efficiency:** Teams can quickly access pre-approved prompts and templates, saving valuable time and reducing duplication of efforts and unnecessary delays in content creation.26  
* **Improved Collaboration:** A shared repository aligns different teams, such as sales, marketing, and content teams, through a unified system for content creation, fostering better teamwork.27  
* **Scalable Workflows:** It allows Aedes to adapt quickly to new campaigns, market demands, or guest needs, scaling AI-driven efforts without compromising quality or consistency.27  
* **Error Reduction:** A repository minimizes discrepancies in tone and messaging, ensuring all content adheres to established brand guidelines and reduces the risk of miscommunication.27

Best practices for organizing and managing this shared prompt library include:

* **Define Clear Goals:** Clearly identify what the repository aims to achieve, whether it is improving brand consistency, enhancing efficiency, or enabling scalability.27  
* **Establish Brand Guidelines:** Document Aedes' preferred tone, style, terminology, and specific "dos and don'ts" for AI-generated content. This should include examples of on-brand messaging.27  
* **Logical Organization:** Categorize prompts for easy navigation. This could be by department (e.g., Marketing, Guest Services), task type (e.g., Social Media, Guest Replies), or content type (e.g., "Guest Reply Templates," "Internal Memo Drafts").26  
* **Choose the Right Tools:** Invest in tools that support version control, collaboration features for team input, analytics to track prompt performance, and efficient content storage and retrieval.27  
* **Train the Team:** Provide regular training sessions and clear documentation on how to effectively use, contribute to, and update the repository. This ensures widespread adoption and proficiency.27  
* **Regular Updates & Reviews:** Continuously add, remove, or update prompts based on feedback from team members and performance data. This keeps the library current and optimized.27  
* **Foster Cross-Team Collaboration:** Encourage open communication and use the repository as a shared resource to align strategies and goals across departments.27

The establishment of a shared prompt library with defined brand guidelines and regular updates 27 represents a practical implementation of "prompt governance." This extends the broader principles of AI governance (transparency, accountability, fairness) 28 to the granular level of AI interaction. By standardizing prompts, Aedes ensures that not just

*what* AI does, but *how* it communicates and represents the brand, aligns with organizational values and policies. This proactive measure prevents individual users from creating "rogue" AI content that could inadvertently damage Aedes' reputation, introduce bias, or violate internal guidelines, thereby ensuring consistent, ethical, and on-brand AI outputs across the organization.

### **4.3 AI Request Intake Form: Capturing Innovation from Staff**

The AI request intake form serves as a centralized mechanism to collect, track, and prioritize AI ideas and problems from all staff members, including non-technical personnel. This form facilitates efficient review and approval workflows for potential AI initiatives, streamlining the process from idea generation to potential implementation.30

The form must be designed for ease of use by non-technical staff, prioritizing clarity and simplicity.30 Key structural and best practice considerations include:

* **Plain Language & Focused Questions:** Frame questions in simple, everyday language, avoiding technical jargon. The focus should be on the "what" and "why" of the idea or problem, rather than the "how" (technical implementation details).30  
* **Concise & Essential Information:** Request only the necessary information to understand the core idea and its potential impact. This brevity encourages completion and reduces intimidation for non-technical users.30  
* **Logical Flow & Order:** Begin with straightforward fields (e.g., name, department, brief idea description) and gradually move to more detailed, but still non-technical, questions. This approach keeps requesters engaged and makes the form less daunting.30  
* **Conditional Logic:** Implement adaptive forms that show only relevant fields based on previous responses. This personalizes the experience for each request type and reduces information overload, making the form more intuitive.30  
* **Group Related Questions:** Organize fields logically. For example, group questions about the problem the staff member is trying to solve, then questions about the desired outcome, and finally any perceived benefits or risks.30  
* **Allow Attachments:** Enable staff to attach relevant documents, diagrams, or examples to provide richer context. Non-technical staff might find it easier to illustrate their ideas visually or with existing materials.30  
* **Centralized Submission:** While staff may use existing communication tools (e.g., email, Slack), the form should centralize all requests into one hub for better visibility and tracking by the AI integration team.30  
* **Automated Routing:** Implement automated workflows to intelligently route submitted ideas to the appropriate teams (e.g., IT, relevant department heads, or an AI steering committee) for review and approval. This avoids manual, error-prone processes and speeds up response times.30

The implementation of an easy-to-use AI request intake form 30 is a strategic move to cultivate an "AI-first" culture within Aedes. By making it simple and accessible for non-technical staff to submit ideas and identify problems AI could solve, Aedes is democratizing innovation. This bottom-up approach empowers employees who are on the front lines of operations to become active participants in the AI journey, ensuring that AI solutions address real, practical business needs and pain points that might otherwise go unnoticed by central IT. This will significantly boost adoption, uncover high-impact use cases, and foster a sense of ownership and collaboration across the organization.

| Field Name | Purpose | Example Input |
| :---- | :---- | :---- |
| **Your Name / Department** | Identifies the submitter and relevant business unit for context. | Jane Doe / Marketing |
| **Problem AI Could Solve** | Clearly defines the current challenge or pain point that AI should address. | Drafting social media posts is time-consuming and inconsistent. |
| **Desired Outcome** | Articulates the measurable success criteria or the ideal state after AI implementation. | Generate 5 unique social media captions in 2 minutes for various platforms. |
| **Expected Benefit** | Quantifies the potential value or return on investment (ROI). | Save 2 hours/week per marketer, ensure consistent brand voice, increase engagement by 10%. |
| **Current Manual Process** | Helps understand current pain points, effort involved, and potential for automation. | Manual drafting, research for trending topics, multiple rounds of editing and approval. |
| **Data Involved (if any)** | Identifies what type of data might be used or generated by the AI solution. | Past social media posts, brand guidelines, product descriptions. |
| **Urgency / Impact** | Helps prioritize requests based on business criticality. | High / Improves brand consistency and efficiency. |
| **Any Other Details / Attachments** | Allows for additional context, examples, or supporting documents. | See attached document for brand voice guidelines and example posts. |

## **5\. Conclusion & Next Steps**

Phase 1 of Aedes’ AI implementation journey has successfully established the foundational pillars necessary for responsible and effective AI adoption. This phase has delivered a comprehensive AI usage policy to ensure data privacy, security, and ethical use; initiated critical staff training to empower employees with AI literacy and prompt engineering skills; and laid the groundwork for a secure AI environment, including the selection of vetted tools, the establishment of a shared prompt library, and the creation of an innovation intake process. These achievements collectively minimize risks, ensure compliance, and cultivate an AI-first culture that leverages collective intelligence for organizational benefit.

Immediate actions following this report include:

* **Finalizing Policy Approval:** Secure formal approval for the drafted AI Usage Policy from senior leadership and legal counsel.  
* **Scheduling Initial Workshops:** Plan and roll out the introductory AI workshops and prompting basics training sessions for all relevant staff.  
* **Selecting Primary AI Workspace:** Make a definitive decision on the primary enterprise-grade AI platform based on the detailed comparison and strategic alignment with Aedes' existing IT infrastructure.  
* **Launching Shared Prompt Library:** Implement the chosen tool for the shared prompt library and populate it with initial templates and brand guidelines.  
* **Deploying AI Request Intake Form:** Launch the non-technical AI request intake form to begin capturing innovation and automation opportunities from staff across all departments.

Looking ahead, AI integration is an iterative journey. Phase 2 will likely focus on pilot projects and the development of more advanced use cases, building directly on the robust foundation established in Phase 1\. Continuous AI governance will remain an ongoing priority, encompassing regular policy reviews, updates to training programs, and the continuous exploration of new opportunities to ensure that AI evolves ethically, securely, and in a value-driven manner for Aedes.

#### **Works cited**

1. AI in Hospitality: Advantages and Use Cases \- NetSuite, accessed on August 19, 2025, [https://www.netsuite.com/portal/resource/articles/business-strategy/ai-hospitality.shtml](https://www.netsuite.com/portal/resource/articles/business-strategy/ai-hospitality.shtml)  
2. Artificial intelligence's impact on hospitality and tourism marketing: exploring key themes and addressing challenges \- Taylor & Francis Online, accessed on August 19, 2025, [https://www.tandfonline.com/doi/full/10.1080/13683500.2023.2229480](https://www.tandfonline.com/doi/full/10.1080/13683500.2023.2229480)  
3. AI in Hospitality: Overview, Use Cases, and Integration Strategies \- MobiDev, accessed on August 19, 2025, [https://mobidev.biz/blog/ai-in-hospitality-use-case-integration-strategies](https://mobidev.biz/blog/ai-in-hospitality-use-case-integration-strategies)  
4. Artificial Intelligence (AI) Acceptable Use Policy Template \- Apparo, accessed on August 19, 2025, [https://apparo.org/wp-content/uploads/2023/07/AI-Acceptable-Use-Template.docx](https://apparo.org/wp-content/uploads/2023/07/AI-Acceptable-Use-Template.docx)  
5. AI Acceptable Use Policy Template | FRSecure, accessed on August 19, 2025, [https://frsecure.com/ai-acceptable-use-policy-template/](https://frsecure.com/ai-acceptable-use-policy-template/)  
6. ChatGPT Security for Enterprises: Risks and Best Practices | Wiz, accessed on August 19, 2025, [https://www.wiz.io/academy/chatgpt-security](https://www.wiz.io/academy/chatgpt-security)  
7. What Is Prompt Engineering? | IBM, accessed on August 19, 2025, [https://www.ibm.com/think/topics/prompt-engineering](https://www.ibm.com/think/topics/prompt-engineering)  
8. Navigating AI Vendor Contracts and the Future of Law: A Guide for Legal Tech Innovators, accessed on August 19, 2025, [https://law.stanford.edu/2025/03/21/navigating-ai-vendor-contracts-and-the-future-of-law-a-guide-for-legal-tech-innovators/](https://law.stanford.edu/2025/03/21/navigating-ai-vendor-contracts-and-the-future-of-law-a-guide-for-legal-tech-innovators/)  
9. What do customers need in contracts for AI products? | Gowling WLG, accessed on August 19, 2025, [https://gowlingwlg.com/en/insights-resources/articles/2025/what-do-customers-need-in-contracts-for-ai-products](https://gowlingwlg.com/en/insights-resources/articles/2025/what-do-customers-need-in-contracts-for-ai-products)  
10. Data, Privacy, and Security for Microsoft 365 Copilot | Microsoft Learn, accessed on August 19, 2025, [https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-privacy](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-privacy)  
11. What is ChatGPT Enterprise? | OpenAI Help Center, accessed on August 19, 2025, [https://help.openai.com/en/articles/8265053-what-is-chatgpt-enterprise](https://help.openai.com/en/articles/8265053-what-is-chatgpt-enterprise)  
12. Is there a difference in data privacy between copilot free and copilot pro? \- Microsoft Learn, accessed on August 19, 2025, [https://learn.microsoft.com/en-us/answers/questions/5434329/is-there-a-difference-in-data-privacy-between-copi](https://learn.microsoft.com/en-us/answers/questions/5434329/is-there-a-difference-in-data-privacy-between-copi)  
13. Generative AI in Google Workspace Privacy Hub, accessed on August 19, 2025, [https://support.google.com/a/answer/15706919?hl=en](https://support.google.com/a/answer/15706919?hl=en)  
14. Gemini Apps Privacy Hub \- Google Help, accessed on August 19, 2025, [https://support.google.com/gemini/answer/13594961?hl=en](https://support.google.com/gemini/answer/13594961?hl=en)  
15. Enterprise \\ Anthropic, accessed on August 19, 2025, [https://www.anthropic.com/enterprise](https://www.anthropic.com/enterprise)  
16. Is Claude AI Safe? Security Measures You Need to Know \- Tactiq, accessed on August 19, 2025, [https://tactiq.io/learn/is-claude-ai-safe](https://tactiq.io/learn/is-claude-ai-safe)  
17. Is my data used for model training? | Anthropic Privacy Center, accessed on August 19, 2025, [https://privacy.anthropic.com/en/articles/10023580-is-my-data-used-for-model-training](https://privacy.anthropic.com/en/articles/10023580-is-my-data-used-for-model-training)  
18. The Role of Artificial Intelligence in Customer Engagement and Social Media Marketing—Implications from a Systematic Review for the Tourism and Hospitality Sectors \- MDPI, accessed on August 19, 2025, [https://www.mdpi.com/0718-1876/20/3/184](https://www.mdpi.com/0718-1876/20/3/184)  
19. 20 Best AI in Travel & Hospitality Case Studies \[2025\] \- DigitalDefynd, accessed on August 19, 2025, [https://digitaldefynd.com/IQ/ai-in-travel-hospitality-case-studies/](https://digitaldefynd.com/IQ/ai-in-travel-hospitality-case-studies/)  
20. AI Applications for Destination Marketing and Management \- NC State Repository, accessed on August 19, 2025, [https://repository.lib.ncsu.edu/bitstreams/0bf2d24d-6bca-4ddf-8dc7-2bd79769574e/download](https://repository.lib.ncsu.edu/bitstreams/0bf2d24d-6bca-4ddf-8dc7-2bd79769574e/download)  
21. AI in Hospitality: Enhancing Guest Experience and Operational Efficiency \- Debut Infotech, accessed on August 19, 2025, [https://www.debutinfotech.com/use-cases/ai-in-hospitality-industry](https://www.debutinfotech.com/use-cases/ai-in-hospitality-industry)  
22. Process Automation: The Key to Efficiency | SAP, accessed on August 19, 2025, [https://www.sap.com/products/technology-platform/process-automation/what-is-process-automation.html](https://www.sap.com/products/technology-platform/process-automation/what-is-process-automation.html)  
23. Prompt Engineering Guide, accessed on August 19, 2025, [https://www.promptingguide.ai/](https://www.promptingguide.ai/)  
24. Overview of prompting strategies | Generative AI on Vertex AI \- Google Cloud, accessed on August 19, 2025, [https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/prompt-design-strategies](https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/prompt-design-strategies)  
25. Creating Effective Prompts: Best Practices and Prompt Engineering, accessed on August 19, 2025, [https://www.visiblethread.com/blog/creating-effective-prompts-best-practices-prompt-engineering-and-how-to-get-the-most-out-of-your-llm/](https://www.visiblethread.com/blog/creating-effective-prompts-best-practices-prompt-engineering-and-how-to-get-the-most-out-of-your-llm/)  
26. The Game-Changer: Mastering the Art of Prompt Repository ..., accessed on August 19, 2025, [https://www.promptpanda.io/blog/prompt-repository/](https://www.promptpanda.io/blog/prompt-repository/)  
27. AI Prompt Repository \- promptpanda.io, accessed on August 19, 2025, [https://www.promptpanda.io/ai-prompt-repository/](https://www.promptpanda.io/ai-prompt-repository/)  
28. What is AI Governance? | IBM, accessed on August 19, 2025, [https://www.ibm.com/think/topics/ai-governance](https://www.ibm.com/think/topics/ai-governance)  
29. What Is AI Governance? \- Palo Alto Networks, accessed on August 19, 2025, [https://www.paloaltonetworks.com/cyberpedia/ai-governance](https://www.paloaltonetworks.com/cyberpedia/ai-governance)  
30. AI Legal Reviews • Template Intake Form for In-House Legal Teams, accessed on August 19, 2025, [https://www.streamline.ai/template/ai-legal-intake-form](https://www.streamline.ai/template/ai-legal-intake-form)  
31. Idea Submission Form Template \- Jotform, accessed on August 19, 2025, [https://www.jotform.com/form-templates/idea-submission-form](https://www.jotform.com/form-templates/idea-submission-form)