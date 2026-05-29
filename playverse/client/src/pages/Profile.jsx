import { useState } from 'react';
import { User, Mail, Lock, Save, Shield, Calendar } from 'lucide-react';
import toast from 'react-hot-toast';
import { authAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { formatDate } from '../utils/helpers';

const Profile = () => {
  const { user, updateUser, isAdmin } = useAuth();
  const [tab, setTab] = useState('profile');
  const [profile, setProfile] = useState({ username: user?.username || '' });
  const [passwords, setPasswords] = useState({ currentPassword: '', newPassword: '', confirm: '' });
  const [saving, setSaving] = useState(false);

  if (!user) return null;

  const handleProfileSave = async (e) => {
    e.preventDefault();
    setSaving(true);
    try {
      const { data } = await authAPI.updateProfile(profile);
      updateUser(data.user);
      toast.success('Profile updated!');
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Failed to update');
    } finally {
      setSaving(false);
    }
  };

  const handlePasswordSave = async (e) => {
    e.preventDefault();
    if (passwords.newPassword !== passwords.confirm) {
      toast.error('Passwords do not match');
      return;
    }
    if (passwords.newPassword.length < 6) {
      toast.error('Password must be at least 6 characters');
      return;
    }
    setSaving(true);
    try {
      await authAPI.changePassword({ currentPassword: passwords.currentPassword, newPassword: passwords.newPassword });
      toast.success('Password changed!');
      setPasswords({ currentPassword: '', newPassword: '', confirm: '' });
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Failed to change password');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="min-h-screen page-container py-8">
      <div className="max-w-2xl mx-auto">
        {/* Header */}
        <div className="card p-6 mb-6 flex items-center gap-5">
          <div className="w-20 h-20 bg-primary-600 rounded-2xl flex items-center justify-center text-white text-3xl font-bold font-gaming shadow-glow">
            {user.username?.[0]?.toUpperCase()}
          </div>
          <div>
            <h1 className="font-gaming text-2xl font-bold text-white">{user.username}</h1>
            <p className="text-gray-500">{user.email}</p>
            <div className="flex items-center gap-3 mt-2">
              {isAdmin && (
                <span className="flex items-center gap-1 text-xs text-primary-400 bg-primary-600/20 border border-primary-600/30 px-2 py-0.5 rounded-full">
                  <Shield size={10} /> Admin
                </span>
              )}
              <span className="flex items-center gap-1 text-xs text-gray-500">
                <Calendar size={10} /> Joined {formatDate(user.createdAt)}
              </span>
              <span className="text-xs text-gray-500">{user.library?.length || 0} games owned</span>
            </div>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-1 bg-gaming-darker rounded-lg p-1 mb-6">
          {[{ id: 'profile', label: 'Profile', icon: User }, { id: 'security', label: 'Security', icon: Lock }].map((t) => (
            <button
              key={t.id}
              onClick={() => setTab(t.id)}
              className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-md text-sm font-semibold transition-all ${tab === t.id ? 'bg-primary-600 text-white' : 'text-gray-400 hover:text-gray-200'}`}
            >
              <t.icon size={15} /> {t.label}
            </button>
          ))}
        </div>

        {/* Profile Tab */}
        {tab === 'profile' && (
          <form onSubmit={handleProfileSave} className="card p-6 space-y-5">
            <h2 className="font-gaming font-bold text-white text-lg">Profile Information</h2>

            <div className="space-y-1">
              <label className="text-gray-400 text-sm">Username</label>
              <div className="flex items-center gap-3 input-field">
                <User size={15} className="text-gray-500" />
                <input
                  type="text"
                  value={profile.username}
                  onChange={(e) => setProfile({ ...profile, username: e.target.value })}
                  className="flex-1 bg-transparent text-gray-100 outline-none text-sm"
                />
              </div>
            </div>

            <div className="space-y-1">
              <label className="text-gray-400 text-sm">Email Address</label>
              <div className="flex items-center gap-3 input-field opacity-60 cursor-not-allowed">
                <Mail size={15} className="text-gray-500" />
                <input type="email" value={user.email} disabled className="flex-1 bg-transparent text-gray-400 outline-none text-sm cursor-not-allowed" />
              </div>
              <p className="text-gray-600 text-xs pl-1">Email cannot be changed.</p>
            </div>

            <button type="submit" disabled={saving} className="btn-primary">
              {saving ? <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <><Save size={15} /> Save Changes</>}
            </button>
          </form>
        )}

        {/* Security Tab */}
        {tab === 'security' && (
          <form onSubmit={handlePasswordSave} className="card p-6 space-y-5">
            <h2 className="font-gaming font-bold text-white text-lg">Change Password</h2>
            {[
              { label: 'Current Password', key: 'currentPassword' },
              { label: 'New Password', key: 'newPassword' },
              { label: 'Confirm New Password', key: 'confirm' },
            ].map(({ label, key }) => (
              <div key={key} className="space-y-1">
                <label className="text-gray-400 text-sm">{label}</label>
                <div className="flex items-center gap-3 input-field">
                  <Lock size={15} className="text-gray-500" />
                  <input
                    type="password"
                    value={passwords[key]}
                    onChange={(e) => setPasswords({ ...passwords, [key]: e.target.value })}
                    className="flex-1 bg-transparent text-gray-100 outline-none text-sm"
                    placeholder="••••••••"
                  />
                </div>
              </div>
            ))}
            <button type="submit" disabled={saving} className="btn-primary">
              {saving ? <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <><Lock size={15} /> Update Password</>}
            </button>
          </form>
        )}
      </div>
    </div>
  );
};

export default Profile;
