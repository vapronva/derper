> **TL;DR**
>
> - Our stuff (build scripts, configs, docs): [WTFPL](#do-what-the-fuck-you-want-to-public-license)
> - Our patches to upstream projects: same license as the project being patched (our original contributions are also available under WTFPL where the upstream license permits)
> - Built outputs (container images, binaries, etc) carry the licenses of whatever they contain — see the [README](./README.md)
> - No warranty + no support + no trademark rights

---

This project is an open-source initiative that builds and packages software from various third-party open-source projects (collectively referred to as **"Original Projects"**) into container images, binaries, packages, and other distributable formats (collectively referred to as "**Distributables**"). \
All scripts, configurations, documentation, and other code originally authored by this project for building the Distributables — excluding any files derived from or based on the Original Projects — are collectively referred to as the "**Build System**". \
Modifications to the Original Projects made by this project — whether provided as `git` patch files, as modified copies of upstream files included directly in this repository, or in any other form — are collectively referred to as "**Patches**".

## Ownership and Licensing

### Distributables

- **Derived Work**: The Distributables created by this project are derived from the Original Projects and may contain multiple components under multiple licenses.
- **Intellectual Property Rights**: All intellectual property rights in the Original Projects remain with their respective rightsholders.
- **Original Licenses**: The Distributables are subject to the license terms and conditions of the Original Projects from which they are derived.
- **User Responsibility**: It is the user's responsibility to review, understand, and comply with the licenses of the Original Projects.
- **Attribution**: Detailed information about the Original Projects and their respective licenses can be found in the [README](./README.md) file.

### Build System

- **License**: The Build System is released under the terms of the _"Do What The Fuck You Want To Public License" (Version 2)_, as published by Sam Hocevar.
- **Permissions**: You are free to use, modify, distribute, and perform any action with the Build System without any restrictions.

### Patches

- **Upstream License Governs**: Patches to Original Projects are derivative works of those Original Projects. The resulting modified works must be used, modified, and distributed in compliance with the license of the Original Project being patched.
- **Original Contributions**: To the extent this project owns copyright in its original changes contained in Patches, those original changes are also made available under the WTFPL (Version 2). This does not override or reduce the obligations imposed by the Original Project's license on the modified work as a whole.
- **Context Material**: Patch files may contain context or other material from the Original Projects; the applicable upstream licenses continue to apply to those portions.
- **Permissive Upstreams**: Where the Original Project uses a permissive license, the Patch is additionally available under the WTFPL at your option.

## Source Availability

Where required by the Original Project's license, the complete corresponding source code, including modifications, is made available in this repository. For AGPL-licensed components included in Distributables, this repository serves as the source offer for network users.

## Disclaimer of Warranty and Limitation of Liability

The Distributables, the Build System, and the Patches are provided "**AS IS**", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or contributors be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the Distributables, the Build System, the Patches, or the use or other dealings in these materials.

## No Support Obligations

- **Personal Project**: This is a personal project provided for community benefit without any commitment to support, maintenance, or updates.
- **Use at Your Own Risk**: Users assume all risks associated with using the Distributables, Build System, and Patches.
- **No Security Guarantees**: No warranties are made regarding the security or stability of the provided software.

## Compliance with Original Licenses

- **Mandatory Compliance**: Use and distribution of the Distributables and Patches remain subject to all applicable license terms and conditions of the Original Projects.
- **User Due Diligence**: Users must review and adhere to the licenses of all Original Projects included in this repository.
- **License Precedence**: In case of conflicts between the WTFPL as applied to the Build System and any Original Project license, the Original Project license takes precedence for its respective components.
- **Access to Licenses**: Refer to the [README](./README.md) or the documentation accompanying each Distributable for specific license information.

## Additional Terms

### Trademarks and Branding

- **No Trademark Rights**: This license does not grant any rights to use the names, logos, or trademarks of the Original Projects or the authors of this project.
- **Permissions Required**: Use of any trademarks, logos, or branding is subject to the respective owners' trademark guidelines and policies and may require additional permissions.

### Contributions

- **Build System Contributions**: Contributions to the Build System are made under the same WTFPL terms unless explicitly stated otherwise.
- **Patch Contributions**: Contributions that modify Original Projects are subject to the license of the respective Original Project.
- **Contributor Responsibility**: Contributors must ensure that their contributions do not violate the licenses of any Original Projects or infringe on any third-party rights.

## Acknowledgments

We acknowledge and are grateful to the Original Projects and their contributors for their work, which makes this project possible.

---

## Do What The Fuck You Want To Public License

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                   Version 2, December 2004

Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE

TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0.  You just DO WHAT THE FUCK YOU WANT TO.
