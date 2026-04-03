import json
import os
import subprocess
from pathlib import Path

# Paths
BASE_DIR = Path(__file__).resolve().parent.parent
CONTENT_DIR = BASE_DIR / "assets" / "content"
EXPORT_DIR = BASE_DIR / "export"

CHROME_PATH = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

def generate_html(lang, data):
    site = data.get('site', {})
    hero = data.get('hero', {})
    about = data.get('about', {})
    experience = data.get('experience', [])
    skills = about.get('skills', [])
    projects = data.get('featuredProjects', [])
    contact = data.get('contact', {})
    
    profile_img_path = about.get('profileImage', 'assets/images/profile.png')
    abs_profile_img = BASE_DIR / profile_img_path
    profile_uri = f"file://{abs_profile_img}" if abs_profile_img.exists() else ""
    
    # Text labels that change with language
    labels = {
        'en': {
            'contact': 'Contact',
            'skills': 'Skills',
            'about': 'About Me',
            'experience': 'Experience',
            'projects': 'Featured Projects',
            'tech': 'Technologies'
        },
        'th': {
            'contact': 'ช่องทางการติดต่อ',
            'skills': 'ทักษะความสามารถ',
            'about': 'ประวัติส่วนตัว',
            'experience': 'ประสบการณ์การทำงาน',
            'projects': 'ผลงานที่โดดเด่น',
            'tech': 'เทคโนโลยี'
        }
    }
    lbl = labels.get(lang, labels['en'])
    
    def render_list(items):
        return "".join(f"<li>{item}</li>" for item in items)
    
    def render_skills(skills_list):
        return "".join(f"<span class='skill-tag'>{s}</span>" for s in skills_list)
        
    def render_experience(exp_list):
        html = ""
        for exp in exp_list:
            html += f"""
            <div class="exp-item">
                <div class="exp-header">
                    <h4>{exp.get('title', '')}</h4>
                    <span class="exp-period">{exp.get('period', '')}</span>
                </div>
                <div class="exp-company">{exp.get('company', '')}</div>
                <div class="exp-summary">{exp.get('summary', '')}</div>
                <ul class="exp-highlights">
                    {render_list(exp.get('highlights', []))}
                </ul>
                <div class="exp-tech"><strong>{lbl['tech']}:</strong> {', '.join(exp.get('tech', []))}</div>
            </div>
            """
        return html
        
    def render_projects(proj_list):
        html = ""
        for idx, proj in enumerate(proj_list):
            if idx > 3: # Limit projects for space in PDF
                break
            html += f"""
            <div class="proj-item">
                <h4>{proj.get('name', '')}</h4>
                <div class="proj-summary">{proj.get('summary', '')}</div>
                <div class="proj-tags">{', '.join(proj.get('tags', []))}</div>
            </div>
            """
        return html
    
    html_content = f"""
    <!DOCTYPE html>
    <html lang="{lang}">
    <head>
        <meta charset="UTF-8">
        <title>Resume - {site.get('ownerName', 'Kitipong Sarajan')}</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Sarabun:wght@300;400;600;700&display=swap');
            
            * {{ box-sizing: border-box; }}
            @page {{ size: A4; margin: 0; }}
            body {{
                font-family: 'Sarabun', sans-serif;
                margin: 0;
                padding: 0;
                color: #334155;
                background-color: #ffffff;
                font-size: 13px;
                line-height: 1.5;
                -webkit-print-color-adjust: exact;
                width: 210mm;
                /* Note: Chrome headless printing manages pagination, avoid fixed height */
            }}
            .resume-wrapper {{
                display: flex;
                min-height: 100vh;
            }}
            .sidebar {{
                width: 32%;
                background-color: #f8fafc;
                padding: 40px 25px;
                border-right: 1px solid #e2e8f0;
            }}
            .main-content {{
                width: 68%;
                padding: 40px 35px;
            }}
            
            .profile-pic {{
                width: 140px;
                height: 140px;
                border-radius: 50%;
                object-fit: cover;
                margin: 0 auto 20px auto;
                display: block;
                border: 3px solid #e2e8f0;
            }}
            .name-title {{
                text-align: center;
                margin-bottom: 30px;
            }}
            .name-title h1 {{
                font-size: 22px;
                margin: 0 0 5px 0;
                color: #0f172a;
            }}
            .name-title h2 {{
                font-size: 14px;
                font-weight: 400;
                color: #64748b;
                margin: 0;
            }}
            
            .section-title {{
                font-size: 16px;
                font-weight: 700;
                color: #0f172a;
                text-transform: uppercase;
                border-bottom: 2px solid #cbd5e1;
                padding-bottom: 5px;
                margin-bottom: 15px;
                margin-top: 30px;
            }}
            .sidebar .section-title {{
                margin-top: 25px;
            }}
            .sidebar .section-title:first-of-type {{
                margin-top: 0;
            }}
            
            .contact-info {{
                margin-bottom: 20px;
            }}
            .contact-item {{
                margin-bottom: 8px;
                font-size: 12px;
                word-break: break-all;
            }}
            .contact-item strong {{ color: #475569; }}
            
            .skills-container {{
                display: flex;
                flex-wrap: wrap;
                gap: 6px;
            }}
            .skill-tag {{
                background-color: #e2e8f0;
                color: #334155;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 11px;
                font-weight: 600;
            }}
            
            .about-text {{
                margin-bottom: 10px;
                text-align: justify;
            }}
            
            .exp-item, .proj-item {{
                margin-bottom: 20px;
            }}
            .exp-header {{
                display: flex;
                justify-content: space-between;
                align-items: baseline;
                margin-bottom: 4px;
            }}
            .exp-header h4, .proj-item h4 {{
                font-size: 15px;
                margin: 0;
                color: #1e293b;
            }}
            .exp-period {{
                font-size: 12px;
                color: #64748b;
                font-weight: 600;
            }}
            .exp-company {{
                font-size: 13px;
                font-weight: 600;
                color: #3b82f6;
                margin-bottom: 6px;
            }}
            .exp-summary, .proj-summary {{
                margin-bottom: 6px;
            }}
            .exp-highlights {{
                margin: 0;
                padding-left: 20px;
                margin-bottom: 8px;
            }}
            .exp-highlights li {{
                margin-bottom: 3px;
            }}
            .exp-tech, .proj-tags {{
                font-size: 12px;
                color: #475569;
            }}
            .proj-tags {{ font-style: italic; }}
            .proj-item {{ break-inside: avoid; }}
            .exp-item {{ break-inside: avoid; }}
            
        </style>
    </head>
    <body>
        <div class="resume-wrapper">
            <div class="sidebar">
                {f'<img src="{profile_uri}" class="profile-pic" alt="Profile">' if profile_uri else ''}
                
                <div class="name-title">
                    <h1>{site.get('ownerName', 'Kitipong Sarajan')}</h1>
                    <h2>{site.get('role', 'Software Engineer')}</h2>
                </div>
                
                <div class="section-title">{lbl['contact']}</div>
                <div class="contact-info">
                    <div class="contact-item"><strong>Email:</strong><br>{site.get('email', contact.get('ctaUrl', '').replace('mailto:', ''))}</div>
                    <div class="contact-item"><strong>Phone:</strong><br>{contact.get('phone', '093-666-4880')}</div>
                    <div class="contact-item"><strong>Line ID:</strong><br>{contact.get('lineId', 'cnxdev')}</div>
                    <div class="contact-item"><strong>Location:</strong><br>{site.get('location', 'Chiang Mai, Thailand')}</div>
                </div>
                
                <div class="section-title">{lbl['skills']}</div>
                <div class="skills-container">
                    {render_skills(skills)}
                </div>
            </div>
            
            <div class="main-content">
                <div class="section-title">{lbl['about']}</div>
                <div>
                    {"".join(f'<p class="about-text">{p}</p>' for p in about.get('paragraphs', [hero.get('description', '')]))}
                </div>
                
                <div class="section-title">{lbl['experience']}</div>
                <div>
                    {render_experience(experience)}
                </div>
                
                <div class="section-title">{lbl['projects']}</div>
                <div>
                    {render_projects(projects)}
                </div>
            </div>
        </div>
    </body>
    </html>
    """
    return html_content

def generate_pdf(lang, filename):
    json_path = CONTENT_DIR / f"portfolio_content_{lang}.json"
    if not json_path.exists():
        print(f"File not found: {json_path}")
        return
        
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    html = generate_html(lang, data)
    html_file = EXPORT_DIR / f"resume_{lang}_temp.html"
    pdf_file = EXPORT_DIR / filename
    
    with open(html_file, 'w', encoding='utf-8') as f:
        f.write(html)
        
    print(f"Generating PDF for {lang} -> {pdf_file}")
    try:
        subprocess.run([
            CHROME_PATH,
            "--headless",
            "--disable-gpu",
            "--no-margins",
            f"--print-to-pdf={pdf_file}",
            f"file://{html_file}"
        ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except FileNotFoundError:
        print("Google Chrome not found. Ensure the path is correct for macOS.")
    except subprocess.CalledProcessError as e:
        print(f"Error executing Chrome: {e.stderr.decode()}")
    finally:
        # Cleanup
        if html_file.exists():
            html_file.unlink()
            
    print(f"Finished generating {pdf_file}")

if __name__ == "__main__":
    generate_pdf("en", "Resume_EN.pdf")
    generate_pdf("th", "Resume_TH.pdf")
    print("Done!")
