<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Family Archive - Complete Interactive Blueprint</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&family=Playfair+Display:ital,wght@0,700;0,900;1,700;1,900&family=Indie+Flower&display=swap');
        
        body { font-family: 'Inter', sans-serif; scroll-behavior: smooth; }
        .font-serif { font-family: 'Playfair Display', serif; }
        .font-handwriting { font-family: 'Indie Flower', cursive; }
        
        .blueprint-grid {
            background-image: linear-gradient(#2c5282 1px, transparent 1px), linear-gradient(90deg, #2c5282 1px, transparent 1px);
            background-size: 25px 25px;
        }

        /* Scrapbook Animations */
        @keyframes marquee {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
        }

        .marquee-container {
            display: flex;
            width: max-content;
            animation: marquee 40s linear infinite;
        }

        .scrapbook-item {
            background: white;
            padding: 12px 12px 30px 12px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            border-radius: 2px;
            width: 280px;
            flex-shrink: 0;
            margin: 0 20px;
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid #e2e8f0;
        }

        .scrapbook-item:nth-child(odd) { transform: rotate(-2deg) translateY(10px); }
        .scrapbook-item:nth-child(even) { transform: rotate(3deg) translateY(-10px); }
        
        .scrapbook-item:hover { 
            transform: scale(1.1) rotate(0deg) !important; 
            z-index: 50;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.2);
        }

        .fade-in { animation: fadeIn 0.6s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="bg-slate-50 text-slate-900">
    <div id="root"></div>

    <script type="text/babel">
        const { useState, useEffect } = React;

        const Icons = {
            Heart: ({className}) => (
                <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
            ),
            User: ({className}) => (
                <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            ),
            Quote: ({className}) => (
                <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M3 21c3 0 7-1 7-8V5c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v6c0 1.1.9 2 2 2h4c0 3.5-1 4.5-4 5"/><path d="M15 21c3 0 7-1 7-8V5c0-1.1-.9-2-2-2h-4c-1.1 0-2 .9-2 2v6c0 1.1.9 2 2 2h4c0 3.5-1 4.5-4 5"/></svg>
            ),
            ArrowLeft: ({className}) => (
                <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
            ),
            Calendar: ({className}) => (
                <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            ),
            Sparkles: ({className}) => (
                <svg className={className} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"/></svg>
            )
        };

        const App = () => {
            const [view, setView] = useState('home');
            const [scrolled, setScrolled] = useState(false);
            const [selectedMember, setSelectedMember] = useState(null);
            const [hoveredRoom, setHoveredRoom] = useState(null);

            useEffect(() => {
                const handleScroll = () => setScrolled(window.scrollY > 50);
                window.addEventListener('scroll', handleScroll);
                return () => window.removeEventListener('scroll', handleScroll);
            }, []);

            const familyMembers = [
                { id: 'papa', name: 'Arnold', role: 'Ang Haligi', photo: 'papa.jpg', pos: { t: '22%', l: '82%' }, room: 'Master Bedroom', bio: 'Ang aming tagapagtanggol at ang master chef tuwing Sunday barbecue.', birthday: 'January 15, 1975', hobby: 'Gardening, Cooking, Woodworking' },
                { id: 'mama', name: 'Melisa', role: 'Ang Ilaw', photo: 'ma.jpg', pos: { t: '35%', l: '82%' }, room: 'Master Bedroom', bio: 'Ang puso ng aming tahanan na nagbibigay ng init at walang hanggang pagmamahal.', birthday: 'May 22, 1978', hobby: 'Reading, Baking, Yoga' },
                { id: 'ate', name: 'Camille', role: 'Panganay', photo: 'cams.jpg', pos: { t: '22%', l: '19%' }, room: 'Bedroom 2', bio: 'Ang creative designer at aming resident life adviser.', birthday: 'August 10, 1998', hobby: 'Digital Art, Photography, Travel' },
                { id: 'kuya', name: 'Harold', role: 'Gitna', photo: 'kuys.jpg', pos: { t: '75%', l: '25%' }, room: 'Living Area', bio: 'Ang sports enthusiast at ang joker ng pamilya.', birthday: 'March 05, 2002', hobby: 'Basketball, Gaming, Guitar' },
                { id: 'bunso', name: 'Justin', role: 'Ang Baby', photo: 'justin.jpg', pos: { t: '22%', l: '45%' }, room: 'Bedroom 3', bio: 'Ang gaming genius at ang aming maliit na bundle of joy.', birthday: 'December 12, 2010', hobby: 'Robotics, Minecraft, Swimming' },
            ];

            const navigateToProfile = (member) => {
                setSelectedMember(member);
                setView('profile');
                window.scrollTo({ top: 0, behavior: 'smooth' });
            };

            const goBack = () => {
                setView('home');
                window.scrollTo({ top: 0, behavior: 'smooth' });
            };

            if (view === 'profile' && selectedMember) {
                return (
                    <div className="min-h-screen bg-white fade-in">
                        <nav className="p-6 flex justify-between items-center border-b sticky top-0 bg-white/80 backdrop-blur-md z-[110]">
                            <button onClick={goBack} className="flex items-center gap-2 text-slate-600 hover:text-blue-600 font-bold transition-colors group">
                                <Icons.ArrowLeft className="w-5 h-5 group-hover:-translate-x-1 transition-transform" /> Bumalik
                            </button>
                            <div className="flex items-center gap-2">
                                <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center text-white shadow-lg">
                                    <Icons.Heart className="w-5 h-5 fill-current" />
                                </div>
                                <span className="font-black text-xl tracking-tighter text-slate-900">FamilyArchive</span>
                            </div>
                        </nav>
                        
                        <div className="max-w-4xl mx-auto px-6 py-16">
                            <div className="flex flex-col md:flex-row gap-12 items-center">
                                <div className="w-full md:w-1/2">
                                    <div className="relative">
                                        <div className="absolute -inset-4 bg-blue-100 rounded-3xl -z-10 rotate-3 animate-pulse"></div>
                                        <img 
                                            src={selectedMember.photo} 
                                            className="w-full aspect-square object-cover rounded-2xl shadow-2xl border-4 border-white transition-transform hover:scale-[1.02] duration-500"
                                            alt={selectedMember.name}
                                            onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=800"; }}
                                        />
                                    </div>
                                </div>
                                <div className="w-full md:w-1/2 text-center md:text-left">
                                    <span className="text-blue-600 font-black text-xs uppercase tracking-[0.3em] bg-blue-50 px-3 py-1 rounded-full">{selectedMember.role}</span>
                                    <h1 className="text-6xl font-serif font-black text-slate-900 mt-4">{selectedMember.name}</h1>
                                    
                                    <div className="mt-8 grid grid-cols-1 gap-4">
                                        <div className="flex items-center gap-4 p-4 bg-slate-50 rounded-xl border border-slate-100">
                                            <div className="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center text-blue-600">
                                                <Icons.User className="w-5 h-5" />
                                            </div>
                                            <div>
                                                <p className="text-[10px] font-black uppercase text-slate-400 tracking-widest">Designated Area</p>
                                                <p className="font-bold text-slate-700">{selectedMember.room}</p>
                                            </div>
                                        </div>
                                        <div className="flex items-center gap-4 p-4 bg-slate-50 rounded-xl border border-slate-100">
                                            <div className="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center text-rose-500">
                                                <Icons.Calendar className="w-5 h-5" />
                                            </div>
                                            <div>
                                                <p className="text-[10px] font-black uppercase text-slate-400 tracking-widest">Special Day</p>
                                                <p className="font-bold text-slate-700">{selectedMember.birthday}</p>
                                            </div>
                                        </div>
                                        <div className="flex items-center gap-4 p-4 bg-slate-50 rounded-xl border border-slate-100">
                                            <div className="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center text-amber-500">
                                                <Icons.Sparkles className="w-5 h-5" />
                                            </div>
                                            <div>
                                                <p className="text-[10px] font-black uppercase text-slate-400 tracking-widest">Passions</p>
                                                <p className="font-bold text-slate-700">{selectedMember.hobby}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div className="mt-20 p-8 bg-slate-900 rounded-3xl text-white relative overflow-hidden">
                                <div className="absolute top-0 right-0 w-32 h-32 bg-blue-600/20 blur-3xl rounded-full -mr-16 -mt-16"></div>
                                <h2 className="text-2xl font-serif font-bold border-b border-white/10 pb-4">Personal Narrative</h2>
                                <p className="mt-6 text-2xl font-serif italic leading-relaxed text-blue-100">"{selectedMember.bio}"</p>
                                <p className="mt-6 text-slate-400 leading-relaxed max-w-2xl">Ang kwento ng bawat miyembro ay pundasyon ng aming tahanan. Bawat alaala ay nakaukit sa mga pader na aming tinitirhan, bumubuo sa isang kasaysayan ng pagmamahalan.</p>
                            </div>
                        </div>
                    </div>
                );
            }

            return (
                <div className="min-h-screen fade-in">
                    <nav className={`fixed top-0 w-full z-[100] transition-all duration-500 ${scrolled ? 'bg-white/95 backdrop-blur shadow-md py-3' : 'bg-transparent py-6'}`}>
                        <div className="max-w-7xl mx-auto px-6 flex justify-between items-center">
                            <div className="flex items-center gap-2">
                                <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center text-white shadow-lg">
                                    <Icons.Heart className="w-5 h-5 fill-current" />
                                </div>
                                <span className={`font-black text-xl tracking-tighter transition-colors ${scrolled ? 'text-slate-900' : 'text-white'}`}>FamilyArchive</span>
                            </div>
                            <div className={`hidden md:flex gap-8 text-xs font-black uppercase tracking-widest ${scrolled ? 'text-slate-600' : 'text-white/80'}`}>
                                <a href="#home" className="hover:text-blue-500 transition-colors">Home</a>
                                <a href="#blueprint" className="hover:text-blue-500 transition-colors">Blueprint</a>
                                <a href="#members" className="hover:text-blue-500 transition-colors">Members</a>
                            </div>
                        </div>
                    </nav>

                    <section id="home" className="relative h-screen flex items-center justify-center overflow-hidden">
                        <div className="absolute inset-0">
                            <img src="bg fam.jpeg" className="w-full h-full object-cover scale-105 animate-[pulse_8s_infinite]" alt="Family Hero Background" />
                            <div className="absolute inset-0 bg-gradient-to-b from-black/70 via-black/30 to-slate-50"></div>
                        </div>
                        <div className="relative z-10 text-center px-6 max-w-4xl text-white">
                            <h1 className="text-5xl md:text-7xl font-serif font-black leading-tight drop-shadow-2xl">
                                A Sanctuary of Our <br/><span className="italic text-blue-300">Beautiful Memories.</span>
                            </h1>
                            <p className="mt-6 text-lg text-white/90 font-medium max-w-2xl mx-auto drop-shadow-lg">
                                Family is where life begins and love never ends. Explore the spaces where our stories unfold and our hearts reside.
                            </p>
                        </div>
                    </section>

                    <section id="blueprint" className="py-24 px-6 bg-slate-50">
                        <div className="max-w-7xl mx-auto">
                            <div className="text-center mb-16">
                                <span className="text-blue-600 font-black text-xs uppercase tracking-[0.3em]">Architectural View</span>
                                <h2 className="text-4xl md:text-5xl font-serif font-black text-slate-900 mt-2">Residential Floor Plan</h2>
                                <p className="text-slate-500 mt-4 text-sm font-bold uppercase tracking-widest">Click a member to view their full profile</p>
                                <div className="w-20 h-1.5 bg-blue-600 mx-auto mt-6 rounded-full"></div>
                            </div>

                            <div className="bg-white border border-slate-200 rounded-3xl shadow-2xl p-4 md:p-12 relative overflow-hidden">
                                <div className="absolute inset-0 opacity-[0.03] pointer-events-none blueprint-grid"></div>
                                <div className="relative aspect-[16/10] w-full max-w-[1000px] mx-auto">
                                    <svg viewBox="0 0 1000 650" className="w-full h-full stroke-slate-800 fill-none stroke-[2]">
                                        <rect x="680" y="50" width="270" height="250" className={`transition-colors duration-500 ${hoveredRoom === 'Master Bedroom' ? 'fill-blue-50' : 'fill-transparent'}`} />
                                        <rect x="50" y="50" width="280" height="250" className={`transition-colors duration-500 ${hoveredRoom === 'Bedroom 2' ? 'fill-blue-50' : 'fill-transparent'}`} />
                                        <rect x="330" y="50" width="240" height="250" className={`transition-colors duration-500 ${hoveredRoom === 'Bedroom 3' ? 'fill-blue-50' : 'fill-transparent'}`} />
                                        <rect x="50" y="300" width="700" height="300" className={`transition-colors duration-500 ${hoveredRoom === 'Living Area' ? 'fill-blue-50' : 'fill-transparent'}`} />

                                        <rect x="50" y="50" width="900" height="550" className="stroke-[4]" />
                                        <line x1="330" y1="50" x2="330" y2="300" />
                                        <line x1="570" y1="50" x2="570" y2="300" />
                                        <line x1="680" y1="50" x2="680" y2="300" />
                                        <line x1="50" y1="300" x2="950" y2="300" />
                                        <line x1="750" y1="300" x2="750" y2="600" />
                                        
                                        <g className="stroke-slate-300 stroke-[1.5]">
                                            <rect x="80" y="80" width="100" height="130" rx="4" />
                                            <rect x="360" y="80" width="100" height="130" rx="4" />
                                            <rect x="720" y="80" width="200" height="150" rx="4" />
                                            <circle cx="625" cy="80" r="15" />
                                            <rect x="100" y="420" width="100" height="100" rx="10" />
                                            <rect x="220" y="420" width="100" height="100" rx="10" />
                                            <circle cx="550" cy="450" r="45" />
                                            <rect x="770" y="330" width="160" height="30" />
                                            <rect x="770" y="550" width="160" height="30" />
                                        </g>

                                        <g className="fill-slate-400 font-sans text-[11px] font-black tracking-[0.2em] uppercase pointer-events-none">
                                            <text x="190" y="275" textAnchor="middle">Bedroom 2</text>
                                            <text x="450" y="275" textAnchor="middle">Bedroom 3</text>
                                            <text x="625" y="290" textAnchor="middle" style={{fontSize: '8px'}}>Bath</text>
                                            <text x="815" y="275" textAnchor="middle">Master Bedroom</text>
                                            <text x="250" y="580" textAnchor="middle">Living Area</text>
                                            <text x="550" y="540" textAnchor="middle">Dining Area</text>
                                            <text x="850" y="460" textAnchor="middle">Kitchen</text>
                                        </g>
                                    </svg>

                                    {familyMembers.map((member) => (
                                        <div 
                                            key={member.id} 
                                            className="absolute z-20" 
                                            style={{ top: member.pos.t, left: member.pos.l }}
                                            onMouseEnter={() => setHoveredRoom(member.room)}
                                            onMouseLeave={() => setHoveredRoom(null)}
                                        >
                                            <button onClick={() => navigateToProfile(member)} className="relative -translate-x-1/2 -translate-y-1/2 group outline-none">
                                                <div className="w-10 h-10 md:w-12 md:h-12 rounded-full bg-white border-2 border-slate-200 shadow-xl flex items-center justify-center transition-all duration-300 transform group-hover:scale-125 group-hover:border-blue-600 group-hover:bg-blue-600 group-hover:text-white">
                                                    <Icons.User className="w-6 h-6" />
                                                </div>
                                                <div className="absolute top-full mt-3 left-1/2 -translate-x-1/2 opacity-0 group-hover:opacity-100 transition-all scale-75 group-hover:scale-100 whitespace-nowrap z-30 pointer-events-none">
                                                    <div className="bg-slate-900 text-white text-[10px] px-3 py-1.5 rounded-md font-black uppercase shadow-2xl flex items-center gap-2">
                                                        <div className="w-1.5 h-1.5 rounded-full bg-blue-400 animate-ping"></div>
                                                        {member.name}
                                                    </div>
                                                </div>
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        </div>
                    </section>

                    <section id="members" className="py-24 bg-white">
                        <div className="max-w-7xl mx-auto px-6 space-y-32">
                            {familyMembers.map((member, index) => (
                                <div key={member.id} className={`flex flex-col ${index % 2 === 0 ? 'md:flex-row' : 'md:flex-row-reverse'} items-center gap-16 group`}>
                                    <div className="flex-1 w-full" onClick={() => navigateToProfile(member)}>
                                        <div className="relative group cursor-pointer overflow-hidden rounded-2xl">
                                            <div className={`absolute -inset-4 bg-slate-100 rounded-3xl -z-10 transform ${index % 2 === 0 ? 'rotate-3' : '-rotate-3'} group-hover:rotate-0 transition-transform duration-700`}></div>
                                            <img 
                                                src={member.photo} 
                                                className="w-full aspect-video md:aspect-square object-cover rounded-2xl shadow-2xl border-4 border-white grayscale group-hover:grayscale-0 group-hover:scale-105 transition-all duration-700" 
                                                alt={member.name} 
                                                onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=800"; }}
                                            />
                                            <div className="absolute bottom-6 left-6 bg-white/90 backdrop-blur-md px-4 py-2 rounded-xl shadow-lg border border-white/50 transform translate-y-2 opacity-0 group-hover:translate-y-0 group-hover:opacity-100 transition-all duration-500">
                                                <p className="text-[10px] font-black uppercase text-blue-600 tracking-widest">{member.room}</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="flex-1 text-center md:text-left">
                                        <div className="mb-4 flex items-center gap-2 justify-center md:justify-start">
                                            <div className="h-px w-8 bg-blue-600"></div>
                                            <span className="text-blue-600 font-black text-xs uppercase tracking-[0.3em]">{member.role}</span>
                                        </div>
                                        <h3 className="text-5xl font-serif font-black text-slate-900 mt-2">{member.name}</h3>
                                        <p className="mt-6 text-slate-500 text-lg leading-relaxed italic border-l-4 border-blue-50 pl-6 group-hover:border-blue-200 transition-colors">"{member.bio}"</p>
                                        <button onClick={() => navigateToProfile(member)} className="mt-8 bg-slate-900 text-white px-8 py-4 rounded-full text-sm font-bold hover:bg-blue-600 transition-all shadow-xl active:scale-95 flex items-center gap-3 mx-auto md:mx-0">
                                            View Full Profile <Icons.ArrowLeft className="w-4 h-4 rotate-180" />
                                        </button>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </section>

                    {/* --- BAGONG SECTION: INFINITE SCRAPBOOK (BAGO MAG FOOTER) --- */}
                    <section className="py-24 bg-[#fcfaf8] overflow-hidden border-y border-slate-200 relative">
                        <div className="max-w-7xl mx-auto px-6 mb-16 relative z-10 text-center">
                            <span className="text-blue-600 font-black text-xs uppercase tracking-[0.3em]">Visual Archive</span>
                            <h2 className="text-4xl md:text-5xl font-serif font-black text-slate-900 mt-2">The Family Scrapbook</h2>
                            <p className="text-slate-500 mt-2 font-handwriting text-xl italic">Treasuring every little moment together.</p>
                        </div>

                        <div className="relative flex group">
                            <div className="marquee-container hover:[animation-play-state:paused]">
                                {/* SET 1 - Pwede mong palitan ang src ng mga photos niyo */}
                                <div className="scrapbook-item">
                                    <img src="memory1.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Summer 2024</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory2.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Christmas Eve</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory3.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1472586662442-3eec04b9dbda?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Family Roadtrip</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory4.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1464695110811-dcf3903da2f2?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Sunday Brunch</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory5.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1542362567-b07e54358756?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Graduation Day</p>
                                </div>

                                {/* SET 2 (Eto yung duplicate para maging infinite ang scroll) */}
                                <div className="scrapbook-item">
                                    <img src="memory1.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1511895426328-dc8714191300?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Summer 2024</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory2.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Christmas Eve</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory3.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1472586662442-3eec04b9dbda?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Family Roadtrip</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory4.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1464695110811-dcf3903da2f2?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Sunday Brunch</p>
                                </div>
                                <div className="scrapbook-item">
                                    <img src="memory5.jpg" className="w-full h-64 object-cover rounded-sm mb-3" alt="Memory" onError={(e) => { e.target.src = "https://images.unsplash.com/photo-1542362567-b07e54358756?w=500"; }} />
                                    <p className="font-handwriting text-slate-600 text-center text-xl">Graduation Day</p>
                                </div>
                            </div>
                        </div>
                    </section>
                    {/* --- END NG BAGONG SECTION --- */}

                    <footer className="bg-slate-900 py-32 px-6 text-white relative overflow-hidden">
                        <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-blue-500 via-rose-500 to-amber-500"></div>
                        <div className="absolute bottom-0 right-0 w-96 h-96 bg-blue-600/10 blur-[120px] rounded-full"></div>
                        <div className="max-w-4xl mx-auto text-center relative z-10">
                            <Icons.Quote className="w-16 h-16 mx-auto mb-12 text-blue-400 opacity-50" />
                            <h2 className="text-3xl md:text-5xl font-serif italic font-medium leading-tight text-slate-100">"Family is not an important thing. It's everything."</h2>
                            <p className="mt-8 text-xs font-black uppercase tracking-[0.4em] text-slate-500">Michael J. Fox</p>
                            <div className="mt-32 pt-16 border-t border-white/5 text-[9px] uppercase tracking-[0.5em] text-slate-600">
                                © 2026 Narrative Architecture System | Hand-crafted for the Family
                            </div>
                        </div>
                    </footer>
                </div>
            );
        };

        const root = ReactDOM.createRoot(document.getElementById('root'));
        root.render(<App />);
    </script>
</body>
</html>
